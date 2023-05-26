`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/21 21:49:32
// Design Name: 
// Module Name: debounce
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


module debounce (clk,key,led);
 
    parameter       N  =  1;                      //Ҫ�����İ���������
 
	input      clk;
    //input             rst;
    input 	   key;
    output reg  led = 1'b1;
                            //����İ���					
	wire     key_pulse;                  //������������������	
    reg        key_rst_pre=1'b0;                //����һ���Ĵ����ͱ����洢��һ������ʱ�İ���ֵ
    reg        key_rst=1'b0;                    //����һ���Ĵ����������洢��ǰʱ�̴����İ���ֵ
    wire       key_edge;                   //��⵽�����ɸߵ��ͱ仯�ǲ���һ��������

    
    reg rst = 1;
    
        //���÷�������ֵ�ص㣬������ʱ�Ӵ���ʱ����״̬�洢�������Ĵ���������
        always @(posedge clk)
          begin
             if (!rst) begin
                 key_rst <= {N{1'b0}};                //��ʼ��ʱ��key_rst��ֵȫΪ1��{}�б�ʾN��1
                 key_rst_pre <= {N{1'b0}};
             end
             else begin
                 key_rst <= key;                     //��һ��ʱ�������ش���֮��key��ֵ����key_rst,ͬʱkey_rst��ֵ����key_rst_pre
                 key_rst_pre <= key_rst;             //��������ֵ���൱�ھ�������ʱ�Ӵ�����key_rst�洢���ǵ�ǰʱ��key��ֵ��key_rst_pre�洢����ǰһ��ʱ�ӵ�key��ֵ
             end    
           end
 
        assign  key_edge = key_rst_pre & (~key_rst);//������ؼ�⡣��key��⵽�½���ʱ��key_edge����һ��ʱ�����ڵĸߵ�ƽ
 
        reg	[20:0]	  cnt = 0;                       //������ʱ���õļ�������ϵͳʱ��12MHz��Ҫ��ʱ20ms����ʱ�䣬������Ҫ18λ������     
 
        //����20ms��ʱ������⵽key_edge��Ч�Ǽ��������㿪ʼ����
        always @(posedge clk)
           begin
             if(!rst)
                cnt <= 18'h0;
             else if(key_edge)
                cnt <= 18'h0;
             else
                cnt <= cnt + 1'h1;
             end  
 
        reg        key_sec_pre = 1'b0;                //��ʱ�����ƽ�Ĵ�������
        reg        key_sec = 1'b0;                    
 
 
        //��ʱ����key���������״̬��Ͳ���һ��ʱ�ӵĸ����塣�������״̬�ǸߵĻ�˵��������Ч
        always @(posedge clk)
          begin
             if (!rst) 
                 key_sec <= {N{1'b0}};                
             else if (cnt==21'h1fffff)
                 key_sec <= key;  
          end
       always @(posedge clk)
          begin
             if (!rst)
                 key_sec_pre <= {N{1'b0}};
             else                   
                 key_sec_pre <= key_sec;             
         end      
       assign  key_pulse = key_sec_pre & (~key_sec);
       
      always @(posedge clk) begin
            if (!rst) 
                led <= 1'b1;
            else if (key_pulse)
                led <= ~led;
            else
               led <= led;
            end         
 
endmodule
