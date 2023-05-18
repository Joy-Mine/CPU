`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/16 22:25:25
// Design Name: 
// Module Name: cache
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


module cache 
#(parameter A_WIDTH=32, parameter C_INDEX=10, parameter D_WIDTH=32) //使用带参数 .h头文件 改动起来方便
//A地址线位宽 D DATA位宽 
//16384 深度？？和地址线 index从0开始 -1
//14bit 2的14次方<16384
//ifetch dmemory 地址信号14。地址和深度 2的14次方
//offset 32 4字节 转换成编制？？ 2bit offset
(clk,resetn, p_a, p_dout, p_din, p_strobe, p_rw, p_ready, m_a, m_dout, m_din, m_strobe, m_rw, m_ready); 
    input clk, resetn; 
    input [A_WIDTH-1:0] p_a; //address of memory tobe accessed 
    input [D_WIDTH-1:0] p_dout; //the data from cpu 
    output [D_WIDTH-1:0] p_din; //the data to cpu 
    input p_strobe; // 1 means to do the reading or writing 片选信号
    input p_rw; // 0:read, 1:write 
    output p_ready; // tell cpu, outside of cpu is ready 
    output [A_WIDTH-1:0] m_a; //address of memory tobe accessed 
    input [D_WIDTH-1:0] m_dout; //the data from memory 
    output [D_WIDTH-1:0] m_din; //the data to memory 
    output m_strobe; //1 means to do the reading or writing 
    output m_rw; //0:read, 1:write 
    input m_ready; //memory is ready

    // d_valie is a piece of memory stored the valid info for every block 
    reg d_valid [ 0 : (1<<C_INDEX)-1]; 
    // T_WIDTH is the width of 'Tag' 
    localparam T_WIDTH = A_WIDTH-C_INDEX-2 ; 
    //d_tags is a piece of memory stored the tag info for every block 
    reg [T_WIDTH-1: 0] d_tags [0 : (1<<C_INDEX)-1]; 
    //d_data is a piece of memory stored the data for every block 
    reg [D_WIDTH-1: 0] d_data [0 : (1<<C_INDEX)-1];

    // d_valie is a piece of memory stored the valid info for every block in cache 
    // d_tags is a piece of memory stored the tag info for every block in cache 
    // d_data is a piece of memory stored the data for every block in cache 
    wire [C_INDEX-1:0] index = p_a[ C_INDEX+1 : 2 ] ; 
    wire [T_WIDTH-1:0] tag = p_a[ A_WIDTH-1 : C_INDEX+2 ] ; //p_a是地址线 找到对应的tag
    wire valid = d_valid[index]; 
    wire [T_WIDTH-1:0] tagout = d_tags[index]; 
    wire [D_WIDTH-1:0] c_dout = d_data[index]; 
    //cache control 

    //按位与 逻辑与等价
    wire cache_hit = valid && (tag==tagout);//对应找到的cache但愿为0/1
    wire cache_miss = ~cache_hit;

    wire c_write = p_rw | cache_miss & m_ready ; 
    integer i;
    always @ (posedge clk, negedge resetn) //异步复位 nededge 0有效
        if( resetn == 1'b0 ) begin  
            for( i=0; i<(1<<C_INDEX); i=i+1 ) 
                d_valid[i] <=1'b0; 
        end 
        else if(c_write==1'b1) 
            d_valid[index] <=1'b1; 
    //////////////////////////////////////////////////////////////////////////////// 
    always @ (posedge clk) 
        if(c_write==1'b1) d_tags[index] <= tag; 
            
    //////////////////////////////////////////////////////////////////////////////// 
    wire sel_in = p_rw ; 
    wire [D_WIDTH-1:0] c_din = sel_in ? p_dout:m_dout ; 
    always @ (posedge clk) 
        if(c_write==1'b1) 
            d_data[index] <= c_din;

    // write data (m_din) to the memory unit specified by m_a 
    assign m_a = p_a; assign m_din = p_dout; 
    // p_strobe (1 means to do the reading or writing, 0 means else) 
    // m_strobe (1 means to do the reading or writing, 0 mean else) 
    // p_rw, m_rw ( 0:read, 1:write) 
    assign m_strobe = p_strobe & (p_rw | cache_miss); 
    assign m_rw = p_strobe & p_rw ;

    //read data to CPU 
    // if cache hit, read c_dout from cache to p_din, else read m_dout to p_in 
    // wire [D_WIDTH-1:0] c_dout = d_data[index]; 
    wire sel_out = cache_hit; 
    assign p_din = sel_out ? c_dout : m_dout; 
    assign p_ready = ~p_rw & cache_hit | (cache_miss | p_rw) & m_ready;


endmodule
