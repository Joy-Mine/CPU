`timescale 1ns / 1ps


module clk_self(
input  clk,
output reg clk_self
);
    parameter NUM = 10000;
    reg [29:0] count;
    always @( posedge  clk )
    begin
        if(count==NUM-1)
        begin 
            clk_self <= ~clk_self;
            count <= 0;
         end
       else
            count <= count+1;
    end
endmodule
