`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/10 17:29:53
// Design Name: 
// Module Name: Register
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


module Register(
    input [4:0] addr,
    input RegWrite,
    input [31:0] writeD,
    input clk,
    output [31:0] data //to data memory
    );
    reg[31:0] register[0:31];
    assign data = register[addr]; 
    always @ (posedge clk)
    begin
        if(RegWrite==1'b1)
            case(addr)
            6'b00_0000:register[addr] <= register[addr];
            default: register[addr] <= writeD;
            endcase
    end
endmodule
