`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module leds (
    input			ledrst,		// reset, active high (复位信号,高电平有效)
    input			led_clk,	// clk for led (时钟信号)
    input			ledwrite,	// led write enable, active high (写信号,高电平有效)
    input			ledcs,		// 1 means the leds are selected as output (从memorio来的，由低至高位形成的LED片选信号)
    //cs表示是否被选中，write是写信号
    //cs来自memorio(在参考设计里这个模块对接所有io，不同的设备有自己单独的片选)
    //write 来自controller(只简单区分是对mem写还是对io写)
    
    input	[1:0]	ledaddr,	// 2'b00 means updata the low 16bits of ledout, 2'b10 means updata the high 8 bits of ledout
    input	[7:0]	ledwdata,	// the data (from register/memorio)  waiting for to be writen to the leds of the board
    output reg	[7:0]	ledout		// the data writen to the leds  of the board
);
    
    always @ (posedge led_clk or posedge ledrst) begin
        if (ledrst)
            ledout <= 24'h000000;
		else if (ledcs && ledwrite) begin
			if (ledaddr == 2'b00)
				ledout[7:0] <= { ledout[7:4],ledwdata[3:0] };
			else if (ledaddr == 2'b10 )
				ledout[7:0] <= { ledwdata[7:4], ledout[3:0] };
			else
				ledout <= ledout;
        end else begin
            ledout <= ledout;
        end
    end
	
endmodule
