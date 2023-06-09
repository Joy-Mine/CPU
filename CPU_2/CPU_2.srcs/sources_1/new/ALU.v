`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/08 10:37:44
// Design Name: 
// Module Name: Executs32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
input [31:0] Read_data_1,
input [31:0] Read_data_2,
input [31:0] Imme_extend,
input [5:0] Function_opcode,
input [5:0] opcode,
input [1:0] ALUOp,
input [4:0] Shamt,
input Sftmd,
input ALUSrc,
input I_format,
input Jr,
input [31:0] PC_plus_4,
output Zero,
output reg [31:0] ALU_Result,
output [31:0] Addr_Result,
output [21:0] ALU_ResultHigh
    );
    
    wire [31:0] Ainput;
    wire [31:0] Binput;
    //wire [31:0] signAinput;
    //wire [31:0] signBinput;
    wire [5:0] Exe_code;
    wire [2:0] ALU_ctl;
    wire [2:0] Sftm;
    reg [31:0] ALU_output_mux;
    reg [31:0] Shift_Result;
    wire [32:0] Branch_Addr;
    
    assign Ainput = Read_data_1;
    assign Binput = (ALUSrc==0)?Read_data_2:Imme_extend;
    //assign signAinput = $signed(Ainput);
    //assign signBinput = $signed(Binput);

    assign Exe_code = (I_format==0)?Function_opcode:{3'b000,opcode[2:0]};
    
    assign ALU_ctl[0] = (Exe_code[0]|Exe_code[3]) & ALUOp[1];
    assign ALU_ctl[1] = ((!Exe_code[2])|(!ALUOp[1]));
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    
    assign Zero = (ALU_output_mux == 32'b0)?1'b1:1'b0;
    
    assign ALU_ResultHigh = ALU_Result[31:10];
    
    always @(ALU_ctl or Ainput or Binput) begin
        case(ALU_ctl)
            3'b000: ALU_output_mux = Ainput & Binput;
            3'b001: ALU_output_mux = Ainput | Binput;
            3'b010: ALU_output_mux = $signed(Ainput) + $signed(Binput); // sign
            3'b011: ALU_output_mux = Ainput + Binput; // unsign
            3'b100: ALU_output_mux = Ainput ^ Binput;
            3'b101: ALU_output_mux = ~(Ainput | Binput);
            3'b110: ALU_output_mux = $signed(Ainput) - $signed(Binput); // sign
            3'b111: ALU_output_mux = Ainput - Binput; // unsign
            default: ALU_output_mux = 32'h00000000;
        endcase
    end
    
    assign Sftm = Function_opcode[2:0];
    assign Branch_Addr = (PC_plus_4[31:2]) + Imme_extend;
    assign Addr_Result = Branch_Addr[31:0];
    always @(*) begin
        if(Sftmd) begin
            case(Sftm)
                3'b000: Shift_Result = Binput << Shamt;
                3'b010: Shift_Result = Binput >> Shamt;
                3'b100: Shift_Result = Binput << Ainput;
                3'b110: Shift_Result = Binput >> Ainput;
                3'b011: Shift_Result = $signed(Binput) >>> Shamt;
                3'b111: Shift_Result = $signed(Binput) >>> Ainput;
                default: Shift_Result = Binput;
            endcase
        end
        else begin
            Shift_Result = Binput;
        end
    end
    
    always @(*) begin 
        //set type operation (slt, slti, sltu, sltiu) 
        if((ALU_ctl==3'b111) && (Exe_code[3:0]==4'b1011)) //sltu
           ALU_Result = (Ainput-Binput<0); 
        else if((ALU_ctl==3'b111) && (Exe_code[3:0]==4'b1010)) //slt
            ALU_Result = ($signed(Ainput)-$signed(Binput)<0); 
        else if((ALU_ctl==3'b111) && (Exe_code[3:0]==4'b0011) && I_format == 1'b1) //sltiu
            ALU_Result = (Ainput-Binput<0);
        else if((ALU_ctl==3'b110) && (Exe_code[3:0]==4'b0010) &&I_format == 1'b1) //slti
           ALU_Result = ($signed(Ainput)-$signed(Binput)<0); 
        //if(((ALU_ctl==3'b111) && (Exe_code[3]==1))||((ALU_ctl[2:1]==2'b11) && (I_format==1)))
        //    ALU_Result = ($signed($signed(Ainput)-$signed(Binput))<0);   
                                 
        //lui operation 
        else if((ALU_ctl==3'b101) && (I_format==1)) 
            ALU_Result[31:0]={Binput[15:0],{16{1'b0}}}; 
    
        //shift operation 
        else if(Sftmd==1) 
            ALU_Result = Shift_Result ; 
    
        //other types of operation in ALU (arithmatic or logic calculation) 
        else 
            ALU_Result = ALU_output_mux[31:0]; 
        end
           
    
endmodule

//    end
//endmodule