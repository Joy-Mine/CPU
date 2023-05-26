`timescale 1ns / 1ps

module Controller(
input [5:0] Opcode,
input [5:0] Function_opcode,

output Jr,//
output RegDST,//
output ALUSrc,//
output MemtoReg,//
output RegWrite,//
output MemWrite,//
output Branch,//
output nBranch,//
output Jmp,//
output Jal,//
output I_format,//
output Sftmd,//
output [1:0] ALUOp//
    );
    wire R_format = (Opcode==6'B000000) ? 1'B1 : 1'B0;
    wire lw,sw;
    assign Jr = (Opcode==6'B000000 && Function_opcode==6'B001000)?1'B1:1'B0;
    assign Jmp = (Opcode==6'B000010)?1'B1:1'B0;
    assign Jal = (Opcode==6'B000011)?1'B1:1'B0;
    wire I_format0 = (R_format==1'B1 || Jr==1'B1 || Jmp==1'B1 || Jal==1'B1)?1'B0:1'B1;//immediate
    assign sw = (Opcode==6'b101011)?1'b1:1'b0;//sw
    assign lw = (Opcode==6'b100011)?1'b1:1'b0;//lw
    assign RegDST = R_format;
    assign Branch = (I_format0==1'B1 && Opcode==6'B000100)?1'B1:1'B0;
    assign nBranch = (I_format0==1'B1 && Opcode==6'B00101)?1'B1:1'B0;
    assign ALUSrc = (I_format0==1'B1 && Opcode!=6'B000100 && Opcode!=6'B00101)?1'B1:1'B0;
    assign MemtoReg = lw;
    assign MemWrite = sw;
    assign RegWrite = (Opcode[5:3] == 3'b001 || MemtoReg==1'B1 || Jal || R_format) && !Jr;
    //assign RegWrite = (Branch==1'B1 || nBranch==1'B1 || MemWrite==1'B1 || Jr==1'B1 || Jmp==1'B1)?1'B0:1'B1;    
    assign Sftmd = (R_format==1'B1 && (Function_opcode==6'B000000 || Function_opcode==6'B000100 || 
    Function_opcode==6'B000010 || Function_opcode==6'B000110 || Function_opcode==6'B000011 || 
    Function_opcode==6'B000111))?1'B1:1'B0;//if shift,set 1
    
    assign I_format = I_format0 && ~Branch && ~nBranch && ~lw && ~sw;
    assign ALUOp = {(R_format||I_format),(Branch||nBranch)};
    
    
endmodule