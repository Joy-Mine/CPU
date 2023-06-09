`timescale 1ns / 1ps

module ALU(Read_data_1,Read_data_2,Sign_extend,Function_opcode,Exe_opcode,ALUOp,
    Shamt,ALUSrc,I_format,Zero,Jr,Sftmd,ALU_Result,Addr_Result,PC_plus_4
    );
//from decoder
    input[31:0] Read_data_1; // 从译码单元的Read_data_1中来 
    input[31:0] Read_data_2; // 从译码单元的Read_data_2中来 
    input[31:0] Sign_extend; // 从译码单元来的扩展后的立即数 
//from IFetc
    input[5:0] Function_opcode; // 取指单元来的r-类型指令功能码,r-form instructions[5:0] 
    input[5:0] Exe_opcode; // 取指单元来的操作码 
    input[4:0] Shamt; // 来自取指单元的instruction[10:6]，指定移位次数 
    input[31:0] PC_plus_4; // 来自取指单元的PC+4 
//from Controller
    input[1:0] ALUOp; // 来自控制单元的运算指令控制编码 
    input Sftmd; // 来自控制单元的，表明是移位指令 
    input ALUSrc; // 来自控制单元，表明第二个操作数是立即数（beq，bne除外） 
    input I_format; // 来自控制单元，表明是除beq, bne, LW, SW之外的I-类型指令 
    input Jr; // 来自控制单元，表明是JR指令 
    
    output Zero; // 为1表明计算值为0 
    output reg [31:0] ALU_Result; // 计算的数据结果 
    output[31:0] Addr_Result; // 计算的地址结果 
    
    
    wire [31:0] Ainput,Binput; // two operands for calculation
    wire [5:0] Exe_code; // use to generate ALU_ctrl. (I_format==0) ? Function_opcode : { 3'b000 , Opcode[2:0] };
    wire [2:0] ALU_ctl; // the control signals which affact operation in ALU directely
    wire [2:0] Sftm; // identify the types of shift instruction, equals to Function_opcode[2:0]
    reg [31:0] Shift_Result; // the result of shift operation
    reg [31:0] ALU_output_mux; // the result of arithmetic or logic calculation
    wire [32:0] Branch_Addr; // the calculated address of the instruction, Addr_Result is Branch_Addr[31:0]

    assign Ainput =Read_data_1;
    assign Binput = (ALUSrc == 0) ? Read_data_2 : Sign_extend[31:0];

    //Exe_code 一个集成
    assign Exe_code= (I_format == 0) ? Function_opcode : {3'b000, Exe_opcode[2:0]};
    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
    assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    
    always @*
    begin
    case(ALU_ctl)
        3'b000:ALU_output_mux = Ainput & Binput;//and andi
        3'b001:ALU_output_mux = Ainput | Binput;//or ori
        3'b010:ALU_output_mux = $signed(Ainput) + $signed(Binput);//add addi lw sw
        3'b011:ALU_output_mux = Ainput + Binput;
        3'b100:ALU_output_mux = Ainput ^ Binput;//xor;
        3'b101:ALU_output_mux = ~(Ainput | Binput);//nor lui
        3'b110:ALU_output_mux = $signed(Ainput) - $signed(Binput); //beq bne sub slti
        3'b111:ALU_output_mux = Ainput - Binput; //subu slitiu slt sltu
        default:ALU_output_mux = 32'h0000_0000;
    endcase
    end
    
    assign Sftm=Function_opcode[2:0];
    always @* begin // six types of shift instructions
    if(Sftmd)
        casex(Sftm[2:0])
            3'b000:Shift_Result = Binput << Shamt;  //sll sllv
            3'b010:Shift_Result = Binput >> Shamt; //srl srlv
            3'b100:Shift_Result = Binput << Ainput;  //sll sllv
            3'b110:Shift_Result = Binput >> Ainput; //srl srlv
            3'b011:begin
                    Shift_Result = $signed(Binput) >>> Shamt;
            end
            3'b111:begin
                    Shift_Result = $signed(Binput) >>> Ainput;
            end
            default:Shift_Result = Binput;
        endcase
    else
        Shift_Result = Binput;
    end
    
    always @* begin
        //slt,slti,sltu,sltiu
    if(((ALU_ctl==3'b111)&&(Exe_code[3]==1))||((ALU_ctl[2:1]==2'b11) && (Exe_opcode[5:1]==5'b00101)))
        ALU_Result =(ALU_output_mux[31] == 1) ? 1:0;
        //lui operation 
    else if((ALU_ctl==3'b101) && (I_format==1))
        ALU_Result = {Sign_extend[15:0],16'b00000000_00000000};
    else if(Sftmd==1'b1)
        ALU_Result = Shift_Result;
    else
        ALU_Result = ALU_output_mux[31:0];
    end


    // 跳转地址
    assign Addr_Result  =( PC_plus_4[31:2] + $signed(Sign_extend))<< 2;
    
    assign Zero = (ALU_output_mux == 32'h0000_000) ? 1'b1 : 1'b0; 
endmodule