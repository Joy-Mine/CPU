`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/10 16:41:57
// Design Name: 
// Module Name: control32_tb
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


module control32_tb();
    reg [5:0] Opcode, Function_opcode; //reg type variables are use for binding with input ports
    wire [21:0] Alu_resultHigh;
    wire [1:0] ALUOp; //wire type variables are use for binding with output ports
    wire Jr, RegDST, ALUSrc, MemorIOtoReg, RegWrite, MemWrite,MemRead,IORead,IOWrite, Branch, nBranch, Jmp, Jal, I_format, Sftmd;

    Controller c32 (Opcode,Function_opcode,Alu_resultHigh,Jr,Jmp,Jal,Branch,nBranch,
    RegDST,MemorIOtoReg,RegWrite,MemWrite,MemRead,IORead,IOWrite,ALUSrc,ALUOp,Sftmd,I_format);




    initial begin
    //an example: #0 add $3,$1,$2. get the machine code of 'add $3,$1,$2'
    //1edit the assembly code, add "add $3,$1,$2"
    //2assembly code in Minisys1Assembler2.2, do the assembly procession
    // step3: open the "output/prgmips32.coe" file, find the related machine code of 'add $3,$1,$2'
    //in "0x00221820", 'Opcode' is 6'h00,'Function_opcode' is 6'h20
        Opcode = 6'h00;
        Function_opcode = 6'h20;
        #10 Opcode = 6'h00; Function_opcode = 6'h08;
        #10 Opcode = 6'h08; Function_opcode = 6'h08;
        #10 Opcode = 6'h23; Function_opcode = 6'h08;
        #10 Opcode = 6'h2b; Function_opcode = 6'h08;
        #10 Opcode = 6'h04; Function_opcode = 6'h08;
        #10 Opcode = 6'h0; Function_opcode = 6'h08;
        #10 Opcode = 6'h02; Function_opcode = 6'h08;
        #10 Opcode = 6'h03; Function_opcode = 6'h08;
        #10 Opcode = 6'h00; Function_opcode = 6'h02;
    end
endmodule
