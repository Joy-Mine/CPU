`timescale 1ns / 1ps

module dememory32_tb;
    reg clock;
    reg MemWrite;
    reg [31:0] addr;
    reg [31:0] writeData;
    wire [31:0] m_rdata;

    // ʵ����dmemory32ģ��
    dmemory32 uut (
        .clock(clock),
        .MemWrite(MemWrite),
        .addr(addr),
        .writeData(writeData),
        .m_rdata(m_rdata)
    );

    // ʱ������
    always begin
        #5 clock = 0; #5 clock = 1;
    end

    // ��������
    initial begin
        // ��ʼ��
        clock = 0;
        MemWrite = 0;
        addr = 0;
        writeData = 0;

        // �ȴ�һ��ʱ������
        #10;

        // д�����ݵ���ַ0
        MemWrite = 1;
        addr = 0;
        writeData = 32'hface_cafe;
        #10;

        // �ر�д�룬��ȡ��ַ0
        MemWrite = 0;
        #10;

        // д�����ݵ���ַ4
        MemWrite = 1;
        addr = 4;
        writeData = 32'hdead_beef;
        #10;

        // �ر�д�룬��ȡ��ַ4
        MemWrite = 0;
        addr = 4;
        #10;

        // ģ�����
        $finish;
    end

endmodule
