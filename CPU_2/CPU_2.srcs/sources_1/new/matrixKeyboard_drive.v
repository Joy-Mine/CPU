`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/22 01:17:44
// Design Name: 
// Module Name: matrixKeyboard_drive
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


module matrixKeyboard_drive(
  input            i_clk,
  input            i_rst,
  input            keyboardcs,
  input[1:0]       keyboardaddr,
  input            boardread,
  input      [3:0] row,                 // ������� ��
  output reg [3:0] col,                 // ������� ��
  output reg [15:0] boarddata        // ����ֵ     
);
 
//++++++++++++++++++++++++++++++++++++++
// ��Ƶ���� ��ʼ
//++++++++++++++++++++++++++++++++++++++
reg [20:0] cnt;                         // ������
 
always @ (posedge i_clk, posedge i_rst)
  if (i_rst)
    cnt <= 0;
  else
    cnt <= cnt + 1'b1;
 
wire key_clk = cnt[20];                // (2^20/50M = 21)ms 
//--------------------------------------
// ��Ƶ���� ����
//--------------------------------------
 
 
//++++++++++++++++++++++++++++++++++++++
// ״̬������ ��ʼ
//++++++++++++++++++++++++++++++++++++++
// ״̬�����٣����������
parameter NO_KEY_PRESSED = 6'b000_001;  // û�а�������  
parameter SCAN_COL0      = 6'b000_010;  // ɨ���0�� 
parameter SCAN_COL1      = 6'b000_100;  // ɨ���1�� 
parameter SCAN_COL2      = 6'b001_000;  // ɨ���2�� 
parameter SCAN_COL3      = 6'b010_000;  // ɨ���3�� 
parameter KEY_PRESSED    = 6'b100_000;  // �а�������

reg [5:0] current_state, next_state;    // ��̬����̬
 
always @ (posedge key_clk, posedge i_rst)
  if (i_rst)
    current_state <= NO_KEY_PRESSED;
  else
    current_state <= next_state;

// ��������ת��״̬
always @ *
  case (current_state)
    NO_KEY_PRESSED :                    // û�а�������
        if (row != 4'hF)
          next_state = SCAN_COL0;
        else
          next_state = NO_KEY_PRESSED;
    SCAN_COL0 :                         // ɨ���0�� 
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = SCAN_COL1;
    SCAN_COL1 :                         // ɨ���1�� 
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = SCAN_COL2;    
    SCAN_COL2 :                         // ɨ���2��
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = SCAN_COL3;
    SCAN_COL3 :                         // ɨ���3��
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = NO_KEY_PRESSED;
    KEY_PRESSED :                       // �а�������
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = NO_KEY_PRESSED;                      
  endcase
 
reg       key_pressed_flag;             // ���̰��±�־
reg [3:0] col_val, row_val;             // ��ֵ����ֵ
 
// ���ݴ�̬������Ӧ�Ĵ�����ֵ
always @ (posedge key_clk, posedge i_rst)
  if (i_rst)
  begin
    col              <= 4'h0;
    key_pressed_flag <=    0;
  end
  else
    case (next_state)
      NO_KEY_PRESSED :                  // û�а�������
      begin
        col              <= 4'h0;
        key_pressed_flag <=    0;       // ����̰��±�־
      end
      SCAN_COL0 :                       // ɨ���0��
        col <= 4'b1110;
      SCAN_COL1 :                       // ɨ���1��
        col <= 4'b1101;
      SCAN_COL2 :                       // ɨ���2��
        col <= 4'b1011;
      SCAN_COL3 :                       // ɨ���3��
        col <= 4'b0111;
      KEY_PRESSED :                     // �а�������
      begin
        col_val          <= col;        // ������ֵ
        row_val          <= row;        // ������ֵ
        key_pressed_flag <= 1;          // �ü��̰��±�־  
      end
    endcase
//--------------------------------------
// ״̬������ ����
//--------------------------------------
 
 
//++++++++++++++++++++++++++++++++++++++
// ɨ������ֵ���� ��ʼ
//++++++++++++++++++++++++++++++++++++++
always @ (posedge key_clk, posedge i_rst)
  if (i_rst)
    boarddata <= 16'h0;
  else
    if (key_pressed_flag)
            case ({col_val, row_val})
              8'b1110_1110 : boarddata <= 16'h0;
              8'b1110_1101 : boarddata <= 16'h4;
              8'b1110_1011 : boarddata <= 16'h8;
              8'b1110_0111 : boarddata <= 16'hC;
               
              8'b1101_1110 : boarddata <= 16'h1;
              8'b1101_1101 : boarddata <= 16'h5;
              8'b1101_1011 : boarddata <= 16'h9;
              8'b1101_0111 : boarddata <= 16'hD;
               
              8'b1011_1110 : boarddata <= 16'h2;
              8'b1011_1101 : boarddata <= 16'h6;
              8'b1011_1011 : boarddata <= 16'hA;
              8'b1011_0111 : boarddata <= 16'hE;
               
              8'b0111_1110 : boarddata <= 16'h3; 
              8'b0111_1101 : boarddata <= 16'h7;
              8'b0111_1011 : boarddata <= 16'hB;
              8'b0111_0111 : boarddata <= 16'hF;
              default: boarddata <= boarddata;        
        endcase
  
    
    
//--------------------------------------
//  ɨ������ֵ���� ����
//--------------------------------------
       
endmodule