`timescale 1ns / 1ps

module Top(
    input fpga_rst, //Active High
    input fpga_clk,
    input[7:0] switch,
    output [7:0] seg_out1,
    output [7:0] seg_out2,
    output [7:0] seg_en
    );
   
    
    wire cpu_clk;
   // UART Programmer Pinouts
    wire upg_clk, upg_clk_o;
    cpuclk cclk(.clk_in1(fpga_clk),
                .clk_out1(cpu_clk),
                .clk_out2(upg_clk));

   
    reg[31:0] segwrite;
    wire[7:0] seg_out;
    wire [31:0] write_data;
    assign write_data={24'h0000_00,switch};
    segtube st(.fpga_clk(fpga_clk),
               .fpga_rst(fpga_rst),  //cpu_rst
               .write_data(write_data), //input from memorio
               .seg_en(seg_en),  //Top output
               .seg_out(seg_out)); //Top output

    assign seg_out1=seg_out;
    assign seg_out2=seg_out;



endmodule
