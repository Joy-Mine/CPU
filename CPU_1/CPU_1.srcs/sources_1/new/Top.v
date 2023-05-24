`timescale 1ns / 1ps

module Top(
    input fpga_rst, //Active High
    input fpga_clk,
    input[7:0] switch,
    input[2:0] smallsw,
    input start_pg,
    // UART Programmer Pinouts
    // start Uart communicate at high level
    input rx,
    
    output [7:0] seg_out1,
    output [7:0] seg_out2,
    output [7:0] seg_en,
    output [7:0] ledout,// from leds
    output tx
    );
    
    wire case_yes;
    wire input_yes;//确认输入
    wire start;//确认开始
    wire switch_case;
    

    
    wire cpu_clk;
   // UART Programmer Pinouts
    wire upg_clk, upg_clk_o;
    wire upg_wen_o; //Uart write out enable
    wire upg_done_o; //Uart rx data have done
    //data to which memory unit of program_rom/dmemory32
    wire [14:0] upg_adr_o;
    //data to program_rom or dmemory32
    wire [31:0] upg_dat_o; 
    
    //reg start_pg;
    wire spg_bufg;
    BUFG U1(.I(start_pg), .O(spg_bufg)); // de-twitter
    // Generate UART Programmer reset signal
    reg upg_rst;
    always @ (posedge fpga_clk) begin
        if (spg_bufg) upg_rst = 0;  
        if (fpga_rst & start_pg == 1'b0) upg_rst = 1;
    end
    //used for other modules which don't relate to UART
    wire rst;
    assign rst = ~fpga_rst | !upg_rst;
    cpuclk cclk(.clk_in1(fpga_clk),.clk_out1(cpu_clk),.clk_out2(upg_clk));
//    wire upg_tx_o;//useless
    uart_bmpg_0 uart(.upg_clk_i(upg_clk),.upg_rst_i(upg_rst),.upg_rx_i(rx),.upg_clk_o(upg_clk_o),
     .upg_wen_o(upg_wen_o),.upg_adr_o(upg_adr_o),.upg_dat_o(upg_dat_o),.upg_done_o(upg_done_o),.upg_tx_o(tx));
    
    
    
    //input部分
    wire [7:0] ioread_data_switch;
    
    assign ioread_data_switch=switch;
   
   wire [31:0] ALU_Result,Read_data_1,Read_data_2,Sign_extend,Addr_Result,branch_base_addr,link_addr,write_data;
   wire [31:0] addr_out,m_rdata,r_wdata,r_rdata;
   wire [7:0] ior_data;
   wire [1:0] ALUOp;
   wire ALUSrc,I_format,Sftmd,Zero,Branch,nBranch,Jmp,Jal,Jr,RegDST,MemorIOtoReg,RegWrite,MemWrite,MemRead,IORead,IOWrite;
   wire ledctrl,switchctrl,segctrl,swsmall;//控制读取地址
    
    wire[31:0] Instruction_o;//要注意rst的什么电平有效 高电平high-effective
    wire[31:0] rom_adr_o;
    
    programrom pgr(cpu_clk,rom_adr_o[15:2]
    ,Instruction_o,upg_rst,upg_clk_o,upg_wen_o&(!upg_adr_o[14]),upg_adr_o[13:0],upg_dat_o,upg_done_o);
    IFetc32 iff(branch_base_addr,  Addr_Result, Read_data_1, Branch, nBranch
    , Jmp, Jal, Jr, Zero,cpu_clk, fpga_rst,link_addr,rom_adr_o,Instruction_o);

    Controller ucc(Instruction_o[31:26],(Instruction_o[5:0]) ,ALU_Result[31:10],Jr,RegDST,ALUSrc,MemorIOtoReg,RegWrite,MemWrite,MemRead,Branch,
                    nBranch,Jmp,Jal,I_format,Sftmd,ALUOp,IORead,IOWrite);

    
    ALU alu(.Read_data_1(Read_data_1),.Read_data_2(Read_data_2),.Sign_extend(Sign_extend),.Function_opcode(Instruction_o[5:0]),.Exe_opcode(Instruction_o[31:26]),.ALUOp(ALUOp),
                .Shamt(Instruction_o[10:6]),.ALUSrc(ALUSrc),.I_format(I_format),.Zero(Zero),.Sftmd(Sftmd),.ALU_Result(ALU_Result),.Addr_Result(Addr_Result),.PC_plus_4(branch_base_addr),
                .Jr(Jr));
        

    MemOrIO mio(MemorIOtoReg,MemWrite,IORead,IOWrite,Addr_Result,
        addr_out,m_rdata,ior_data,r_wdata,Read_data_1,write_data,ledctrl
        ,switchctrl,swsmall, segctrl);
//            input[31:0] r_rdata; // data read from Decoder(register file)//对应readdata1 
//            output reg[31:0] write_data; //data to memory or I/O（m_wdata,io_wdata)

    // input	[7:0]	ledwdata,	// the data (from register/memorio)  waiting for to be writen to the leds of the board
    //wire ledwrite; //led write enable, active high (写信号,高电平有效)
    
    //这里有个问题就是到底write哪7个bit进去呢？？？按道理来说 可以根据题目晚上一下大概！！！
    //这里我是用了后七位 比较关系的话 可以给一个东西赋值为1 就可以体现在led上 刚好是最低的bit
    //2的幂和奇数也可以相似的去做 奇数用一个rem 寄存器的值就直接会得到1
    
    //基本测试场景2中 溢出检测也是 比较最高一个bit 存在1在一个寄存器中 体现在LED中！！
    //注意：只能存1！！！比较方便
    leds l(rst,cpu_clk,IOWrite,ledctrl,write_data[7:0],ledout);
    ioread ur(.reset(rst), .ior(IORead), .switchctrl(switchctrl), .swsmall(swsmall) ,
    . ioread_data_switch(switch),.ioread_small_switch(smallsw),.ioread_data(ior_data));
   
    
    //addr_out需要是14位长度 
    dmemory32 dm(cpu_clk,MemWrite,addr_out[15:2],write_data,m_rdata,upg_rst,upg_clk_o,upg_wen_o&upg_adr_o[14],upg_adr_o[13:0],upg_dat_o,upg_done_o);
    Decoder ude(Read_data_1,Read_data_2,Instruction_o,r_wdata/*mem_data*/,ALU_Result,
                 Jal,RegWrite,MemorIOtoReg,RegDST,Sign_extend,cpu_clk,fpga_rst,link_addr);
    //mem_data  从DATA RAM or I/O port取出的数据
    //        input[31:0] r_rdata; // data read from Decoder(register file)from MEMorIO
    //  m_rdata ->  output [31:0] ram_dat_o, // the data read from data-ram
    
    
    reg[31:0] segwrite;
    wire[7:0] seg_out;
    segtube st(fpga_clk,rst,segctrl,write_data,seg_en,seg_out);
    assign seg_out1=seg_out;
    assign seg_out2=seg_out;
   

endmodule