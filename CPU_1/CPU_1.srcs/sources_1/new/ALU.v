`timescale 1ns / 1ps

module ALU(Read_data_1,Read_data_2,Sign_extend,Function_opcode,Exe_opcode,ALUOp,
    Shamt,ALUSrc,I_format,Zero,Jr,Sftmd,ALU_Result,Addr_Result,PC_plus_4
    );
//from decoder
    input[31:0] Read_data_1; // �����뵥Ԫ��Read_data_1���� 
    input[31:0] Read_data_2; // �����뵥Ԫ��Read_data_2���� 
    input[31:0] Sign_extend; // �����뵥Ԫ������չ��������� 
//from IFetc
    input[5:0] Function_opcode; // ȡָ��Ԫ����r-����ָ�����,r-form instructions[5:0] 
    input[5:0] Exe_opcode; // ȡָ��Ԫ���Ĳ����� 
    input[4:0] Shamt; // ����ȡָ��Ԫ��instruction[10:6]��ָ����λ���� 
    input[31:0] PC_plus_4; // ����ȡָ��Ԫ��PC+4 
//from Controller
    input[1:0] ALUOp; // ���Կ��Ƶ�Ԫ������ָ����Ʊ��� 
    input Sftmd; // ���Կ��Ƶ�Ԫ�ģ���������λָ�� 
    input ALUSrc; // ���Կ��Ƶ�Ԫ�������ڶ�������������������beq��bne���⣩ 
    input I_format; // ���Կ��Ƶ�Ԫ�������ǳ�beq, bne, LW, SW֮���I-����ָ�� 
    input Jr; // ���Կ��Ƶ�Ԫ��������JRָ�� 
    
    output Zero; // Ϊ1��������ֵΪ0 
    output reg [31:0] ALU_Result; // ��������ݽ�� 
    output[31:0] Addr_Result; // ����ĵ�ַ��� 
    
    
    wire [31:0] Ainput,Binput; // two operands for calculation
    wire [5:0] Exe_code; // use to generate ALU_ctrl. (I_format==0) ? Function_opcode : { 3'b000 , Opcode[2:0] };
    wire [2:0] ALU_ctl; // the control signals which affact operation in ALU directely
    wire [2:0] Sftm; // identify the types of shift instruction, equals to Function_opcode[2:0]
    reg [31:0] Shift_Result; // the result of shift operation
    reg [31:0] ALU_output_mux; // the result of arithmetic or logic calculation
    wire [32:0] Branch_Addr; // the calculated address of the instruction, Addr_Result is Branch_Addr[31:0]

    assign Ainput =Read_data_1;
    assign Binput = (ALUSrc == 0) ? Read_data_2 : Sign_extend[31:0];

    //Exe_code һ������
    assign Exe_code= (I_format == 0) ? Function_opcode : {3'b000, Exe_opcode[2:0]};
    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
    assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    
    always @*/*(ALU_ctl or Ainput or Binput)*/
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
            3'b011:Shift_Result = $signed(Binput) >>> Shamt;
            3'b111:Shift_Result = $signed(Binput) >>> Ainput;
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


    // ��ת��ַ
    assign Addr_Result  =( PC_plus_4[31:2] + $signed(Sign_extend))<< 2;
    
    assign Zero = (ALU_output_mux == 32'h0000_000) ? 1'b1 : 1'b0; 
endmodule