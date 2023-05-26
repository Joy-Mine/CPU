`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/20 12:08:50
// Design Name: 
// Module Name: Decoder
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


module Decoder(
output[31:0] read_data_1,
output[31:0] read_data_2,
output[31:0] imme_extend,
input[31:0] Instruction,
input[31:0] read_data,
input[31:0] ALU_result,
input Jal,
input RegWrite,
input MemtoReg,
input RegDst,
input clock,
input reset,
input[31:0] opcplus4
    ); 
    reg[31:0] register[0:31];
    wire[5:0] opcode;
    wire[4:0] read_register_1;
    wire[4:0] read_register_2;
    reg[4:0] write_register;
    reg[31:0] write_data;
    wire[4:0] write_register_1;
    wire[4:0] write_register_2;
    wire[15:0] immediate_value;
    wire sign;

    
    assign opcode = Instruction[31:26];
    assign read_register_1 = Instruction[25:21];//rs
    assign read_register_2 = Instruction[20:16];//rt
    assign write_register_1 = Instruction[15:11];//rd r-format
    assign write_register_2 = Instruction[20:16];//rt i-format
    assign immediate_value = Instruction[15:0];
    assign sign = Instruction[15];
    
    assign imme_extend = (opcode==6'b001100||opcode==6'b001101||opcode==6'b001110)?{{16{1'b0}},immediate_value}:{{16{sign}},immediate_value};
    
    assign read_data_1 = register[read_register_1];
    assign read_data_2 = register[read_register_2];
    
    always@* begin
        if(RegWrite==1'b1)begin
            if(opcode==6'b000011&&Jal==1'b1)begin
                write_register = 5'b11111;
            end
            else if(RegDst==1'b1)begin
                write_register = write_register_1;
            end
            else begin
                write_register = write_register_2;
            end
        end
    end
    
    always@* begin
        if(Jal==1'b1) begin
            write_data = opcplus4;
        end
        else if(MemtoReg==1'b0)begin
            write_data = ALU_result;
        end
        else begin
            // from I/O or Memory
            write_data = read_data;
        end
    end
    integer i;
    always@(posedge clock) begin
        if(reset==1'b1) begin
            for(i=0;i<32;i=i+1)register[i]<=32'd0;
        end
        else if(RegWrite==1'b1)begin
            if(write_register!=5'd0)begin
                register[write_register]<=write_data;
            end
        end
    end
       
endmodule