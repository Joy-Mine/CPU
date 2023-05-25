`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/25 11:39:49
// Design Name: 
// Module Name: prgrom_tb
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


//    prgrom instmem (    
//    .clka (kickOff ? rom_clk_i : upg_clk_i ),
//    .wea (kickOff ? 1'b0 : upg_wen_i ),
//    .addra (kickOff ? rom_adr_i : upg_adr_i ),
//    .dina (kickOff ? 32'h00000000 : upg_dat_i ),
//    .douta (Instruction_o)
//);

module prgrom_tb ();
reg[31:0] PC;
reg clock=1'b0;
wire [31:0] Instruction;
prgrom instmem(.clka(clock),.wea(1'b0),.addra(PC[15:2]),.dina(32'h00000000),.douta(Instruction));
always #5 clock = ~clock;
initial begin
    clock = 1'b0;
#2 PC = 32'h0000_0000;
repeat(5) begin
#10 PC = PC+4;
#10 $finish;
end end endmodule