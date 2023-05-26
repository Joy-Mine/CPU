`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module ioread (
    input			reset,				// reset, active high 复位信号 (高电平有效)
	input			ior,				// from Controller, 1 means read from input device(从控制器来的I/O读)
    input			switchctrl,			// 从input得到
    input          swsmall,
    input	[7:0]	ioread_data_switch,	// the data from switch(从外设来的读数据，此处来自拨码开关)
    input [2:0]    ioread_small_switch,
    output reg	[7:0]	ioread_data 		// the data to memorio (将外设来的数据送给memorio)
);
   
    always @(*)  begin
        if (reset)
            ioread_data = 8'h00;
        else if (ior == 1) begin
            if (switchctrl == 1)
                ioread_data = ioread_data_switch;
            else if(swsmall==1)
                ioread_data={5'b00000,ioread_small_switch};
        end
        else ioread_data=ioread_data;
    end
    //分不同情况考虑到底是怎么输入的
	
endmodule











//备份

// module ioread (
//     input			reset,				// reset, active high 复位信号 (高电平有效)
// 	input			ior,				// from Controller, 1 means read from input device(从控制器来的I/O读)
//     input			switchctrl,			// means the switch is selected as input device (从memorio经过地址高端线获得的拨码开关模块片选)
//     input	[15:0]	ioread_data_switch,	// the data from switch(从外设来的读数据，此处来自拨码开关)
//     output	[15:0]	ioread_data 		// the data to memorio (将外设来的数据送给memorio)
// );
    
//     reg [15:0] ioread_data;
    
//     always @* begin
//         if (reset)
//             ioread_data = 16'h0;
//         else if (ior == 1) begin
//             if (switchctrl == 1)
//                 ioread_data = ioread_data_switch;
//             else
// 				ioread_data = ioread_data;
//         end
//     end
    
//     //分不同情况考虑到底是怎么输入的
	
// endmodule