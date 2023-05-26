`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/18 12:07:51
// Design Name: 
// Module Name: CPU_sim
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


module CPU_tb(

    );
    
    reg fpga_clk = 1;
    
    reg fpga_rst = 1;
    
    reg start_pg = 1;
    
    reg upg_rx = 0;
    
    reg [23:0]switch;
    
    wire [23:0]led;
    
    wire [7:0] DIG;
    
    wire [7:0] Y;
    
    wire upg_tx;
    
    
    
    CPU_UART A1 (DIG,
        Y,
        fpga_clk,
        fpga_rst,
        led,
        start_pg,
        switch,
        upg_rx,
        upg_tx);
    
    always #1 begin
        fpga_clk = ~fpga_clk;
    end
    
    initial begin
        #500 start_pg = 1'b0;
        #10 fpga_rst = 1'b0;
        switch = 24'd0;
     end

    
endmodule
