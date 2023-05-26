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
    
    
    
    //input����
   wire [31:0] ALU_Result,Read_data_1,Read_data_2,Sign_extend,Addr_Result,branch_base_addr,link_addr,write_data;
   wire [31:0] addr_out,m_rdata,r_wdata;
   wire [7:0] ior_data;
   wire [1:0] ALUOp;
   wire ALUSrc,I_format,Sftmd,Zero,Branch,nBranch,Jmp,Jal,Jr,RegDST,MemorIOtoReg,RegWrite,MemWrite,MemRead,IORead,IOWrite;
   wire ledctrl,switchctrl,segctrl,swsmall;//���ƶ�ȡ��ַ
    
    wire[31:0] Instruction_o;//Ҫע��rst��ʲô��ƽ��Ч �ߵ�ƽhigh-effective
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


    Controller ucc(.Opcode(Instruction_o[31:26]),           // ����IFetchģ���ָ���6bit
                   .Function_opcode(Instruction_o[5:0]) ,   // ����IFetchģ���ָ���6bit����������r-�����е�ָ��
                   .Alu_resultHigh(ALU_Result[31:10]),
                   .Jr(Jr),
                   .RegDST(RegDST),     // Ϊ1����Ŀ�ļĴ�����rd��Ϊ0ʱ��ʾĿ�ļĴ�����rt
                   .ALUSrc(ALUSrc),     // Ϊ1�����ڶ�����������ALU�е�Binput��������������beq��bne���⣩��Ϊ0ʱ��ʾ�ڶ������������ԼĴ���
                   .MemorIOtoReg(MemorIOtoReg), // Ϊ1�����Ӵ洢����I/O��ȡ����д���Ĵ�����Ϊ0ʱ��ʾ��ALUģ���������д���Ĵ���
                   .RegWrite(RegWrite),     // Ϊ1������ָ����Ҫд�Ĵ�����Ϊ0ʱ��ʾ����Ҫд�Ĵ���--to Reg
                   .MemWrite(MemWrite),     // Ϊ1������ָ����Ҫд�洢����Ϊ0ʱ��ʾ����Ҫд������--to MemOrIO
                   .MemRead(MemRead),       //to Memorio
                   .Branch(Branch),
                   .nBranch(nBranch),
                   .Jmp(Jmp),
                   .Jal(Jal),
                   .I_format(I_format),
                   .Sftmd(Sftmd),           //��λָ��
                   .ALUOp(ALUOp),           // ��ָ��ΪR-type��I_formatΪ1ʱ��ALUOp�ĸ߱���λΪ1������߱���λΪ0; ��ָ��Ϊbeq��bneʱ��ALUOp�ĵͱ���λΪ1������ͱ���λΪ0
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
                .write_data(write_data),//output data to memory or I/O��m_wdata,io_wdata)
                .ledctrl(ledctrl),          //LED Chip Select
                .switchctrl(switchctrl),    //Switch Chip Select 
                .swsmall(swsmall),
                .segctrl(segctrl));


    //�����и�������ǵ���write��7��bit��ȥ�أ�������������˵ ���Ը�����Ŀ����һ�´�ţ�����
    //�����������˺���λ �ȽϹ�ϵ�Ļ� ���Ը�һ��������ֵΪ1 �Ϳ���������led�� �պ�����͵�bit
    //2���ݺ�����Ҳ�������Ƶ�ȥ�� ������һ��rem �Ĵ�����ֵ��ֱ�ӻ�õ�1
    
    //�������Գ���2�� ������Ҳ�� �Ƚ����һ��bit ����1��һ���Ĵ����� ������LED�У���
    //ע�⣺ֻ�ܴ�1�������ȽϷ���

    leds l(.ledrst(rst),
           .led_clk(cpu_clk),
           .ledwrite(IOWrite),          //write ����controller(ֻ�������Ƕ�memд���Ƕ�ioд)
           .ledcs(ledctrl),             //cs����memorio(�ڲο���������ģ��Խ�����io����ͬ���豸���Լ�������Ƭѡ)
           .ledwdata(write_data[7:0]),  // the data (from register/memorio)  waiting for to be writen to the leds of the board
           .ledout(ledout));            // top output the data writen to the leds  of the board

    ioread ur(.reset(rst), 
              .ior(IORead),                 // from Controller, 1 means read from input device(�ӿ���������I/O��)
              .switchctrl(switchctrl), 
              .swsmall(swsmall),
              .ioread_data_switch(switch),  // the data from switch(���������Ķ����ݣ��˴����Բ��뿪��)
              .ioread_small_switch(smallsw),
              .ioread_data(ior_data));      //output the data to memorio (���������������͸�memorio)


    //addr_out��Ҫ��14λ���� 
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
                .Instruction(Instruction_o),// ȡָ��Ԫ����ָ��
                .mem_data(r_wdata),         //  ��DATA RAM or I/O portȡ��������--r_wdata from memorIO
                .ALU_result(ALU_Result),    // ��ִ�е�Ԫ��������Ľ��
                .Jal(Jal),                  //  ���Կ��Ƶ�Ԫ��˵����JALָ�� 
                .RegWrite(RegWrite),        // ���Կ��Ƶ�Ԫ
                .MemtoReg(MemorIOtoReg),    // ���Կ��Ƶ�Ԫ
                .RegDst(RegDST),
                .clock(cpu_clk),
                .reset(rst),
                .opcplus4(link_addr)
//                ,.value(register_value)
//                ,.value2(value2)
                );   // ����ȡָ��Ԫ��JAL����


    
    //mem_data  ��DATA RAM or I/O portȡ��������
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