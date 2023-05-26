`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/10 17:20:25
// Design Name: 
// Module Name: Decoder
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

module Decoder(read_data_1,read_data_2,Instruction,mem_data,ALU_result,
                 Jal,RegWrite,MemtoReg,RegDst,Sign_extend,clock,reset,opcplus4
                 //,value,value2
                 );
                 //output [31:0]value;output[31:0] value2;
    output  [31:0] read_data_1;               // ����ĵ�һ������
    output  [31:0] read_data_2;               // ����ĵڶ�������
    input[31:0]  Instruction;               // ȡָ��Ԫ����ָ��
    input[31:0]  mem_data;   				//  ��DATA RAM or I/O portȡ��������--r_wdata from memorIO
    input[31:0]  ALU_result;   				// ��ִ�е�Ԫ��������Ľ��
    input        Jal;                       //  ���Կ��Ƶ�Ԫ��˵����JALָ�� 
    input        RegWrite;                  // ���Կ��Ƶ�Ԫ
    input        MemtoReg;              // ���Կ��Ƶ�Ԫ
    input        RegDst;             
    output reg [31:0] Sign_extend;               // ��չ���32λ������
    input		 clock,reset;                // ʱ�Ӻ͸�λ
    input[31:0]  opcplus4;                 // ����ȡָ��Ԫ��JAL����
    
    reg[31:0] register [0:31];
    wire[5:0] opcode;
    wire[5:0] Function_opcode;
    wire[15:0] immediate;
    wire [4:0] rt,rd,rs;
    reg [31:0]write_data;
    reg [4:0]write_addr;

//assign value = register[1];
//assign value2 = register[28];


    wire [31:0]zero_immediate;
    reg [31:0]sign_immediate, branch_immediate;

    assign opcode=Instruction[31:26];
    assign Function_opcode=Instruction[5:0];
    assign rs=Instruction[25:21];
    assign rt=Instruction[20:16];
    assign rd=Instruction[15:11];
    assign immediate = Instruction[15:0];

    assign zero_immediate={16'b00000000_00000000,immediate};

    always @(*) begin
        if(immediate[15]==1'b1) begin
            sign_immediate={16'b11111111_11111111,immediate};
            branch_immediate={14'b11111111_111111,immediate,2'b0};
        end
        else begin
            sign_immediate={16'b00000000_00000000,immediate};
            branch_immediate={14'b00000000_000000,immediate,2'b0};
        end 
    end
    always @* begin
        if(opcode==6'b001001||opcode==6'b001100||opcode==6'b001100||opcode==6'b001101||opcode==6'b001011||opcode==6'b001110) 
        //sltiu andi ori XORI
            Sign_extend=zero_immediate;
        else Sign_extend=sign_immediate;
    end
    
    

    assign read_data_1 = register[rs];
    assign read_data_2 = register[rt];

    integer i;
    always @(negedge clock ) begin //�Ҹĵ�
        if(reset==1'b1) begin
            for(i=0;i<32;i=i+1) register[i]=32'h00000000;
        end
        else begin
                if(RegWrite==1'b1&&write_addr!=5'b00000) 
                    register[write_addr]=write_data;
        end
    end

    //assign Sign_extend=(immediate[15]==1'b1) ? {16'h1111,immediate} : {16'h0000,immediate} ;

    always @(posedge clock) begin
        if(RegWrite==1'b1) begin
            if(Jal==1'b1) write_addr=5'b11111; 
            else if(RegDst==1'b1) write_addr = rd;
            else write_addr = rt;
        end
    end

        always @(posedge clock) begin
        if(RegWrite==1'b1) begin
            if(Jal==1'b1) begin 
                write_data=opcplus4;
            end
            else if(MemtoReg==1'b0) begin
                // if(opcode==6'b000000&&(Function_opcode==6'b101010||Function_opcode==6'b101011))
                //     write_data=(read_data_1<read_data_2)?1:0;
                // else if(opcode==6'b101010||opcode==6'b101011) 
                //     write_data=(read_data_1<sign_immediate)?1:0;
                // else 
                write_data=ALU_result;
            end
            else write_data=mem_data;
        end
    end


    
//    always @(posedge clock ) begin
//        if(RegWrite==1'b1&&write_addr!=6'b000000) 
//            register[write_addr]=write_data;
//    end
endmodule
