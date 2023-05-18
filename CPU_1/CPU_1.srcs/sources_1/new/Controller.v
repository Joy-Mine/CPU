`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/10 15:31:54
// Design Name: 
// Module Name: Controller
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


module Controller(Opcode, Function_opcode,Alu_resultHigh,  Jr, RegDST, ALUSrc, MemorIOtoReg, RegWrite, MemWrite, MemRead, Branch, nBranch, Jmp, Jal, I_format, Sftmd, ALUOp, IORead, IOWrite );
    input[5:0]   Opcode;            // instruction[31..26] - the high 6 bits of the instruction from the IFetch module
    input[5:0]   Function_opcode;  	// instructions[5..0] - the low 6 bits of the instruction from the IFetch module, used to distinguish instructions in r-type
    input[21:0] Alu_resultHigh; // From the execution unit Alu_Result[31..10] 

    output       Jr;         	 // 1 if the current instruction is jr, 0 otherwise
    output       RegDST;          // 1 if the destination register is rd, 0 if the destination register is rt
    output       ALUSrc;          // 1 if the second operand (Binput in ALU) is an immediate value (except for beq, bne), otherwise the second operand comes from the register
    output       MemorIOtoReg;     // 1 if data written to register is read from memory or I/O, 0 if data written to register is the output of ALU module
    output       RegWrite;   	  // 1 if the instruction needs to write to register, 0 otherwise
    output       MemWrite;       //  1 if the instruction needs to write to memory, 0 otherwise
    output       MemRead; // 1 indicates that the instruction needs to read from the memory
    output       Branch;        //  1 if the current instruction is beq, 0 otherwise
    output       nBranch;       //  1 if the current instruction is bne, 0 otherwise
    output       Jmp;            //  1 if the current instruction is j, 0 otherwise
    output       Jal;            //  1 if the current instruction is jal, 0 otherwise
    output       I_format;      //  1 if the instruction is I-type except for beq, bne, lw and sw; 0 otherwise
    output       Sftmd;         //  1 if the instruction is a shift instruction, 0 otherwise
    output[1:0] ALUOp;        // if the instruction is R-type or I_format, ALUOp's higher bit is 1, 0 otherwise; if the instruction is ??¨²beq??? or ??¨²bne???, ALUOp's lower bit is 1, 0 otherwise
    output IORead; // 1 indicates I/O read 
    output IOWrite; //1 indicates I/O write


    wire R_format,Lw,Sw;
    assign Lw=(Opcode==6'b100011) ? 1'b1 : 1'b0;
    assign Sw=(Opcode==6'b101011) ? 1'b1 : 1'b0;
    assign Jr=((Opcode==6'b000000)&&(Function_opcode==6'b001000)) ? 1'b1 : 1'b0;
    assign Jmp=(Opcode==6'b000010) ? 1'b1 : 1'b0;
    assign Jal=(Opcode==6'b000011) ? 1'b1 : 1'b0;
    assign Branch=(Opcode==6'b000100) ? 1'b1 : 1'b0;
    assign nBranch=(Opcode==6'b000101) ? 1'b1 : 1'b0;
    assign RegDST=(Opcode==6'b000000) ? 1'b1 : 1'b0;
    assign I_format=(Opcode[5:3]==3'b001) ? 1'b1 : 1'b0;
    assign R_format=(Opcode==6'b000000) ? 1'b1 : 1'b0;
    
    assign RegWrite = (R_format || Lw || Jal || I_format) && !(Jr) ; // Write memory or write IO 
    
    assign ALUOp = { (R_format || I_format) , (Branch || nBranch) };    
    assign ALUSrc=(Opcode[5:3]==3'b001||Opcode[5]==1'b1) ? 1'b1 : 1'b0;
    assign Sftmd = (((Function_opcode==6'b000000)||(Function_opcode==6'b000010)
    ||(Function_opcode==6'b000011)||(Function_opcode==6'b000100)||(Function_opcode==6'b000110)
    ||(Function_opcode==6'b000111))&&R_format) ? 1'b1:1'b0;

    assign MemWrite = ((Sw==1) && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1'b1:1'b0;
    //assign MemWrite = ((Sw==1)) ? 1'b1:1'b0;
    assign MemRead = ((Opcode==6'b100011)&& (Alu_resultHigh[21:0] != 22'h3FFFFF)) ?1'b1:1'b0;
    //assign MemtoReg = (Opcode==6'b100011) ?1'b1:1'b0;

    assign IORead =((Sw==1) && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ?1'b1:1'b0;
    assign IOWrite = ((Opcode==6'b100011)&& (Alu_resultHigh[21:0] == 22'h3FFFFF)) ?1'b1:1'b0;
    // Read operations require reading data from memory or I/O to write to the register 

    assign MemorIOtoReg = IORead || MemRead;

endmodule
