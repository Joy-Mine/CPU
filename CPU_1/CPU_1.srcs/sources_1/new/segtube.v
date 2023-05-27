`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/18 17:17:22
// Design Name: 
// Module Name: segtube
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


module segtube(
    input fpga_clk,
    input fpga_rst,
    input segctrl,
    input[31:0] write_data,
    
    output[7:0] seg_en,
    output reg[7:0] seg_out
    );
    //数码管输出相关
    reg[3:0] sw;
    reg [16:0] count_250hz;
    reg pos=1'b0;     //500hz 
    reg [2:0] wz_out;   //decide which seg should light up
    reg [7:0] wz;     //the boolean of which should light
    //assign seg_en=( write_data==32'h00000000)? 8'b00000000: wz;
    assign seg_en=wz;
    //assign seg_en=( write_data==32'h00000000)? 8'b00000000: wz;
    always@(posedge fpga_clk) begin //250z 产生一个pos来变化seg亮灯状态
        if(count_250hz == 17'd100000) begin
            count_250hz <= 0;
            pos <= 1'b1;
        end
        else begin
            count_250hz <= count_250hz +1;
            pos <= 1'b0;
        end   
    end

    always@(posedge pos) begin //用一个counter表达亮灯的状态
        if(fpga_rst)
            wz_out<=0;
        else if(wz_out== 7)
            wz_out <= 0;
        else
            wz_out <= wz_out + 1;  //use out to represent 8 kinds of flashing
    end
        
    always@(posedge fpga_clk) begin //亮灯的状态（具体的)
        case(wz_out)
            3'd7: wz<=8'b10000000;
            3'd6: wz<=8'b01000000;
            3'd5: wz<=8'b00100000;
            3'd4: wz<=8'b00010000;
            3'd3: wz<=8'b00001000;
            3'd2: wz<=8'b00000100;
            3'd1: wz<=8'b00000010;
            3'd0: wz<=8'b00000001;
        endcase
    end
    
    reg[31:0] segwrite=32'h0000_0000;
    always @ (posedge fpga_clk) begin
        if (fpga_rst)
            segwrite = 32'h0000_0000;
        else if (segctrl) begin
            segwrite = write_data;
        end else begin
            segwrite = segwrite;
         end
    end
        
    always@(posedge fpga_clk) begin //表达到每一位上 有一位用来表达状态 每一位 用了ans来代表暂时的答案
        case(wz_out)
            3'd0: sw <= segwrite[3:0];
            3'd1: sw <= segwrite[7:4];
            3'd2: sw <= segwrite[11:8];
            3'd3: sw <= segwrite[15:12];
            3'd4: sw <= segwrite[19:16];
            3'd5: sw <= segwrite[23:20];
            3'd6: sw <= segwrite[27:24];
            3'd7: sw <= segwrite[31:28];
            default: sw<=4'b0000;
        endcase
    end
   

    always@(posedge fpga_clk) begin//数码管表现数字
        case(sw)
            4'h0:seg_out<=8'b1111_1100;//0
            4'h1:seg_out<=8'b0110_0000;
            4'h2:seg_out<=8'b1101_1010;//2
            4'h3:seg_out<=8'b1111_0010;
            4'h4:seg_out<=8'b0110_0110;
            4'h5:seg_out<=8'b1011_0110;
            4'h6:seg_out<=8'b1011_1110;//6
            4'h7:seg_out<=8'b1110_0000;
            4'h8:seg_out<=8'b1111_1110;
            4'h9:seg_out<=8'b1111_0110;
            4'hA:seg_out<= 8'b1110_1110; // A
            4'hB:seg_out<= 8'b0011_1110; // B
            4'hC:seg_out<= 8'b1001_1100; // C
            4'hD:seg_out<= 8'b0111_1010; // D
            4'hE:seg_out<= 8'b1001_1110; // E
            4'hF:seg_out<= 8'b1000_1110; // F
            default:seg_out<=8'b0001_0000;//-
        endcase
    end 
//    always@(posedge fpga_clk) begin//数码管表现数字
//           seg_out1=seg_out;
//           seg_out2=seg_out;
//        end 
endmodule
