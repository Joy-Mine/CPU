`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/10 19:23:01
// Design Name: 
// Module Name: IFetc32
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


module IFetc32(branch_base_addr, Addr_result, Read_data_1,// Insturction_o,
     Branch, nBranch, Jmp, Jal, Jr, Zero, clock, reset, link_addr,rom_adr_o,Insturction_i);

    input [31:0] Insturction_i;
   // output [31:0] Insturction_o;
    output [31:0] branch_base_addr; // (pc+4) to ALU which is used by branch type instruction
    output reg [31:0] link_addr; // (pc+4) to Decoder which is used by jal instruction
    output [31:0] rom_adr_o;
    
    input clock, reset; // Clock and reset
    
    //assign Insturction_o=Insturction_i;
    
    // from ALU
    input [31:0] Addr_result; // the calculated address from input Zero; // while Zero is 1, it means the ALUresult is zero
    input Zero;

    // from Decoder
    input[31:0] Read_data_1; // the address of instruction used by jr instruction
    
    // from Controller
    input Branch; //while Branch is 1,it means current instruction is beq
    input nBranch; // while nBranch is 1,it means current instruction is bnq
    input Jmp; // while Jmp 1, it means current instruction is jump
    input Jal; //while Jal is 1, it means current instruction is`      jal
    input Jr; // while Jr is 1, it means current instruction is jr
    
    reg[31:0] PC=32'b0, Next_PC=32'b0;
    
//    prgrom instmem(
//    .clka(clock),
//    .addra(PC[15:2]),
//    .douta(Instruction)
//    );
    
    always @* 
    begin
        if(((Branch == 1) && (Zero == 1 )) || ((nBranch == 1) && (Zero == 0))) // beq, bne
            Next_PC = Addr_result; // the calculated new value for PC
        else if(Jr == 1)
            Next_PC =  Read_data_1; // the value of $31 register
        else Next_PC = PC+4; // PC+4
    end

    always @(negedge clock) begin
    if(reset ==1'b1) begin
        PC <= 32'h0000_0000;
        link_addr<=32'h0000_0000;
    end
    else begin
        if(Jmp == 1) begin
            PC <= {PC[31:28], Insturction_i[25:0], 2'b0};
        end
        else if(Jal == 1)begin
            link_addr <= PC+4;
            PC <= {PC[31:28], Insturction_i[25:0], 2'b0};
        end
        else PC <= Next_PC;
        end
    end
    always @(posedge clock) begin
        if(reset ==1'b1)
            link_addr=32'h0000_0000;
        else if(Jal == 1)
            link_addr = PC+4;
        else link_addr=link_addr;
    end
     
    assign rom_adr_o=PC;
    assign branch_base_addr=PC+4;

endmodule
