`timescale 1ns / 1ps

module dememory32_tb;
    reg clock;
    reg MemWrite;
    reg [31:0] addr;
    reg [31:0] writeData;
    wire [31:0] m_rdata;

    // 实例化dmemory32模块
    dmemory32 uut (
        .clock(clock),
        .MemWrite(MemWrite),
        .addr(addr),
        .writeData(writeData),
        .m_rdata(m_rdata)
    );

    // 时钟驱动
    always begin
        #5 clock = 0; #5 clock = 1;
    end

    // 测试序列
    initial begin
        // 初始化
        clock = 0;
        MemWrite = 0;
        addr = 0;
        writeData = 0;

        // 等待一个时钟周期
        #10;

        // 写入数据到地址0
        MemWrite = 1;
        addr = 0;
        writeData = 32'hface_cafe;
        #10;

        // 关闭写入，读取地址0
        MemWrite = 0;
        #10;

        // 写入数据到地址4
        MemWrite = 1;
        addr = 4;
        writeData = 32'hdead_beef;
        #10;

        // 关闭写入，读取地址4
        MemWrite = 0;
        addr = 4;
        #10;

        // 模拟结束
        $finish;
    end

endmodule
