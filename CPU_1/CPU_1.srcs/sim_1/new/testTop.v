`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/25 01:46:58
// Design Name: 
// Module Name: testTop
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


module testTop(

    );
    
    reg clk = 1'b0, rst = 1'b1,but = 1'b0,rx = 1'b0,start_pg = 1'b0;
    wire tx,IORead;
   //reg [2:0] sw = 3'b0;
//    wire[3:0]state;
    wire[7:0]
    lights,
//    switchValue1,
    seg,
    seg1,
    an;
//    wire [5:0]disp_dat;
//    ledctrl;
    reg [2:0]choose = 3'b001;
    //wire [31:0] segValue;
//    addr,ins,write,ALU_result,io_rdata,
//    ,decvalue

    //top t(clk,rst,but,sw,rx,start_pg,choose,tx,lights,seg,seg1,an,segValue
//    ,addr,write,ins,ALU_result,decvalue
//    ,io_rdata,IORead,switchValue1,state,disp_dat
  //  );
    wire[3:0] ledsmall;
    reg [7:0] sw=8'b0;
    Top tt(rst,clk,sw,choose,start_pg,rx,ledsmall, seg,seg1,an,lights,tx);
    
    
    initial begin
        forever #5 clk = ~clk;
    end
//    initial begin
//        forever #10 upg_clk = ~upg_clk;
//    end
    initial begin
        #100
        rst = 1'b0;
        #100
        rst = 1'b1;
        #3000
        sw = 8'b0000_0001;
        but = 1'b1;
        #1000
        but = 1'b0;
        #1000
        sw =  8'b0000_0011;
        but = 1'b1;
        #1000
        but = 1'b0;
        #1000
        sw = 8'b0000_0100;
        but = 1'b1;
        #1000
        but = 1'b0;
        #1000
        sw =  8'b0000_1011;
        but = 1'b1;
        #1000
        but = 1'b0;
        #1000
        sw =  8'b0000_1111;
        but = 1'b1;
        #1000
        sw =  8'b0001_0011;
        but = 1'b1;
        #1000
        sw = 8'b0101_0011;
        #1000
        sw = 8'b0101_0111;;
        but = 1'b1;
        #1000
        but = 1'b0;
        #1000
        sw = 8'b0000_0010;
        but = 1'b1;
        #1000
        sw = 8'b0000_0011;
        but = 1'b1;
        #3000 $finish();
    end
endmodule

