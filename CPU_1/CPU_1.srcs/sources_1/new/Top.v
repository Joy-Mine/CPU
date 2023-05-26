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
    output [3:0] ledsmall,
    output [7:0] seg_out1,
    output [7:0] seg_out2,
    output [7:0] seg_en,
    output [7:0] ledout,// from leds
    output tx
//    ,output[31:0] instruction,
//    output [31:0]alu_resultt,
//    output [31:0]write_dataa,
//    output [31:0]register_value,
//    output [31:0] value2,
//    output iorr,
//    output ioww,
//    output [31:0]rrwdata,
//    output cpuclk
    );
   
   assign ledsmall={start_pg,smallsw};
    
    wire cpu_clk;
   // UART Programmer Pinouts
    wire upg_clk, upg_clk_o;
    wire upg_wen_o; //Uart write out enable
    wire upg_done_o; //Uart rx data have done
    wire [14:0] upg_adr_o;    //data to which memory unit of program_rom/dmemory32
    wire [31:0] upg_dat_o;     //data to program_rom or dmemory32
    
    //reg start_pg;
    wire spg_bufg;
    BUFG U1(.I(start_pg), 
            .O(spg_bufg)); // de-twitter
            
    // Generate UART Programmer reset signal
    reg upg_rst;
    always @ (posedge fpga_clk) begin
        if (spg_bufg) upg_rst = 0;  
        if (fpga_rst & start_pg == 1'b0) upg_rst = 1;
    end

    //used for other modules which don't relate to UART
    wire rst;
    assign rst = ~fpga_rst | !upg_rst;
    cpuclk cclk(.clk_in1(fpga_clk),
                .clk_out1(cpu_clk),
                .clk_out2(upg_clk));

    uart_bmpg_0 uart(.upg_clk_i(upg_clk),
                     .upg_rst_i(upg_rst),
                     .upg_rx_i(rx),
                     .upg_clk_o(upg_clk_o),//output
                     .upg_wen_o(upg_wen_o),
                     .upg_adr_o(upg_adr_o),
                     .upg_dat_o(upg_dat_o),
                     .upg_done_o(upg_done_o),
                     .upg_tx_o(tx));
    
    
    
    //input部分
   wire [31:0] ALU_Result,Read_data_1,Read_data_2,Sign_extend,Addr_Result,branch_base_addr,link_addr,write_data;
   wire [31:0] addr_out,m_rdata,r_wdata;
   wire [7:0] ior_data;
   wire [1:0] ALUOp;
   wire ALUSrc,I_format,Sftmd,Zero,Branch,nBranch,Jmp,Jal,Jr,RegDST,MemorIOtoReg,RegWrite,MemWrite,MemRead,IORead,IOWrite;
   wire ledctrl,switchctrl,segctrl,swsmall;//控制读取地址
    
    wire[31:0] Instruction_o;//要注意rst的什么电平有效 高电平high-effective
    wire[31:0] rom_adr_o;
    
//    assign instruction=Instruction_o;
//    assign write_dataa=write_data;
//    assign iorr=IORead;
//    assign ioww=IOWrite;
//    assign alu_resultt=ALU_Result;
//    assign rrwdata=r_wdata;
//    assign cpuclk=cpu_clk;
    
    programrom pgr(.rom_clk_i(cpu_clk), // ROM clock
                   .rom_adr_i(rom_adr_o[15:2]), // From IFetch
                   .Instruction_o(Instruction_o), //output to IFetch
                   .upg_rst_i(upg_rst),  // UPG reset (Active High)
                   .upg_clk_i(upg_clk_o),  // UPG clock (10MHz)
                   .upg_wen_i(upg_wen_o&(!upg_adr_o[14])),  // UPG write enable
                   .upg_adr_i(upg_adr_o[13:0]),  // UPG write address
                   .upg_dat_i(upg_dat_o),  // UPG write data
                   .upg_done_i(upg_done_o));// 1 if program finished


    IFetc32 iff(.branch_base_addr(branch_base_addr),// (pc+4) to ALU which is used by branch type instruction
                .link_addr(link_addr),  // (pc+4) to Decoder which is used by jal instruction
                .rom_adr_o(rom_adr_o),//ouput
                .Addr_result(Addr_Result),
                .Read_data_1(Read_data_1),
                .Branch(Branch), 
                .nBranch(nBranch),
                .Jmp(Jmp),
                .Jal(Jal), 
                .Jr(Jr), 
                .Zero(Zero),
                .clock(cpu_clk), 
                .reset(rst),
                .Insturction_i(Instruction_o));


    Controller ucc(.Opcode(Instruction_o[31:26]),           // 来自IFetch模块的指令高6bit
                   .Function_opcode(Instruction_o[5:0]) ,   // 来自IFetch模块的指令低6bit，用于区分r-类型中的指令
                   .Alu_resultHigh(ALU_Result[31:10]),
                   .Jr(Jr),
                   .RegDST(RegDST),     // 为1表明目的寄存器是rd，为0时表示目的寄存器是rt
                   .ALUSrc(ALUSrc),     // 为1表明第二个操作数（ALU中的Binput）来自立即数（beq，bne除外），为0时表示第二个操作数来自寄存器
                   .MemorIOtoReg(MemorIOtoReg), // 为1表明从存储器或I/O读取数据写到寄存器，为0时表示将ALU模块输出数据写到寄存器
                   .RegWrite(RegWrite),     // 为1表明该指令需要写寄存器，为0时表示不需要写寄存器--to Reg
                   .MemWrite(MemWrite),     // 为1表明该指令需要写存储器，为0时表示不需要写储存器--to MemOrIO
                   .MemRead(MemRead),       //to Memorio
                   .Branch(Branch),
                   .nBranch(nBranch),
                   .Jmp(Jmp),
                   .Jal(Jal),
                   .I_format(I_format),
                   .Sftmd(Sftmd),           //移位指令
                   .ALUOp(ALUOp),           // 当指令为R-type或I_format为1时，ALUOp的高比特位为1，否则高比特位为0; 当指令为beq或bne时，ALUOp的低比特位为1，否则低比特位为0
                   .IORead(IORead),
                   .IOWrite(IOWrite));

    
    ALU alu(.Read_data_1(Read_data_1),
            .Read_data_2(Read_data_2),
            .Sign_extend(Sign_extend),
            .Function_opcode(Instruction_o[5:0]),
            .Exe_opcode(Instruction_o[31:26]),
            .ALUOp(ALUOp),
            .Shamt(Instruction_o[10:6]),
            .ALUSrc(ALUSrc),
            .I_format(I_format),
            .Zero(Zero),
            .Sftmd(Sftmd),
            .ALU_Result(ALU_Result),
            .Addr_Result(Addr_Result),
            .PC_plus_4(branch_base_addr),
            .Jr(Jr));
        


    MemOrIO mio(.rst(rst),
                .mRead(MemRead),    //from controller
                .mWrite(MemWrite),
                .ioRead(IORead),
                .ioWrite(IOWrite),
                .addr_in(ALU_Result),   //from ALU
                .m_rdata(m_rdata),      //data read from Data-Memory
                .io_rdata(ior_data),    //read from IO,8 bits
                .r_rdata(Read_data_2),      // data read from Decoder(register file)
                .r_wdata(r_wdata),      //output data to Decoder(register file)
                .addr_out(addr_out),    //output address to Data-Memory
                .write_data(write_data),//output data to memory or I/O（m_wdata,io_wdata)
                .ledctrl(ledctrl),          //LED Chip Select
                .switchctrl(switchctrl),    //Switch Chip Select 
                .swsmall(swsmall),
                .segctrl(segctrl));


    //这里有个问题就是到底write哪7个bit进去呢？？？按道理来说 可以根据题目晚上一下大概！！！
    //这里我是用了后七位 比较关系的话 可以给一个东西赋值为1 就可以体现在led上 刚好是最低的bit
    //2的幂和奇数也可以相似的去做 奇数用一个rem 寄存器的值就直接会得到1
    
    //基本测试场景2中 溢出检测也是 比较最高一个bit 存在1在一个寄存器中 体现在LED中！！
    //注意：只能存1！！！比较方便

    leds l(.ledrst(rst),
           .led_clk(cpu_clk),
           .ledwrite(IOWrite),          //write 来自controller(只简单区分是对mem写还是对io写)
           .ledcs(ledctrl),             //cs来自memorio(在参考设计里这个模块对接所有io，不同的设备有自己单独的片选)
           .ledwdata(write_data[7:0]),  // the data (from register/memorio)  waiting for to be writen to the leds of the board
           .ledout(ledout));            // top output the data writen to the leds  of the board

    ioread ur(.reset(rst), 
              .ior(IORead),                 // from Controller, 1 means read from input device(从控制器来的I/O读)
              .switchctrl(switchctrl), 
              .swsmall(swsmall),
              .ioread_data_switch(switch),  // the data from switch(从外设来的读数据，此处来自拨码开关)
              .ioread_small_switch(smallsw),
              .ioread_data(ior_data));      //output the data to memorio (将外设来的数据送给memorio)


    //addr_out需要是14位长度 
    dmemory32 dm(.ram_clk_i(cpu_clk),       // from CPU top
                 .ram_wen_i(MemWrite),      // from Controller
                 .ram_adr_i(addr_out[15:2]),// from alu_result of ALU
                 .ram_dat_i(write_data),    // from read_data_2 of Decoder
                 .ram_dat_o(m_rdata),       // output the data read from data-ram
                 .upg_rst_i(upg_rst),       // UPG reset (Active High)
                 .upg_clk_i(upg_clk_o),     // UPG ram_clk_i (10MHz)
                 .upg_wen_i(upg_wen_o&upg_adr_o[14]),// UPG write enable
                 .upg_adr_i(upg_adr_o[13:0]), // UPG write address
                 .upg_dat_i(upg_dat_o),       // UPG write data
                 .upg_done_i(upg_done_o));    // 1 if programming is finished

    Decoder ude(.read_data_1(Read_data_1),  //output
                .read_data_2(Read_data_2),  //output
                .Sign_extend(Sign_extend),  //output
                .Instruction(Instruction_o),// 取指单元来的指令
                .mem_data(r_wdata),         //  从DATA RAM or I/O port取出的数据--r_wdata from memorIO
                .ALU_result(ALU_Result),    // 从执行单元来的运算的结果
                .Jal(Jal),                  //  来自控制单元，说明是JAL指令 
                .RegWrite(RegWrite),        // 来自控制单元
                .MemtoReg(MemorIOtoReg),    // 来自控制单元
                .RegDst(RegDST),
                .clock(cpu_clk),
                .reset(rst),
                .opcplus4(link_addr)
//                ,.value(register_value)
//                ,.value2(value2)
                );   // 来自取指单元，JAL中用


    
    //mem_data  从DATA RAM or I/O port取出的数据
    //        input[31:0] r_rdata; // data read from Decoder(register file)from MEMorIO
    //  m_rdata ->  output [31:0] ram_dat_o, // the data read from data-ram
    
    
    wire[7:0] seg_out;
    
    
    segtube st(.fpga_clk(fpga_clk),
               .fpga_rst(rst),  //cpu_rst
               .segctrl(segctrl),  //input from memorio
               .write_data(write_data), //input from memorio
//               .segctrl(1'b1),  //input from memorio
//                              .write_data(Instruction_o), //input from memorio
               .seg_en(seg_en),  //Top output
               .seg_out(seg_out)); //Top output

    assign seg_out1=seg_out;
    assign seg_out2=seg_out;



endmodule