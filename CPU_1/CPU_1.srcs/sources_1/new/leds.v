`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module leds (
    input			ledrst,		// reset, active high (��λ�ź�,�ߵ�ƽ��Ч)
    input			led_clk,	// clk for led (ʱ���ź�)
    input			ledwrite,	// led write enable, active high (д�ź�,�ߵ�ƽ��Ч)
    input			ledcs,		// 1 means the leds are selected as output (��memorio���ģ��ɵ�����λ�γɵ�LEDƬѡ�ź�)
    //cs��ʾ�Ƿ�ѡ�У�write��д�ź�
    //cs����memorio(�ڲο���������ģ��Խ�����io����ͬ���豸���Լ�������Ƭѡ)
    //write ����controller(ֻ�������Ƕ�memд���Ƕ�ioд)
    
    input	[7:0]	ledwdata,	// the data (from register/memorio)  waiting for to be writen to the leds of the board
    output reg	[7:0]	ledout		// the data writen to the leds  of the board
);
    
    always @ (posedge led_clk or posedge ledrst) begin
        if (ledrst)
            ledout <= 8'h00;
		else if (ledcs && ledwrite) begin
			ledout[7:0] <= ledwdata;
        end else begin
            ledout <= ledout;
        end
    end
	
endmodule
