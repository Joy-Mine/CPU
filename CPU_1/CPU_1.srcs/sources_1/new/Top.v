`timescale 1ns / 1ps

module Top(
    input fpga_rst, //Active High
    input fpga_clk,
    input[7:0] switch,
    input[4:0] btn,
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
    
    assign case_yes=btn[0];
    assign input_yes=btn[1];
    assign start=btn[2];
    assign switch_case=btn[3];
    
    wire cpu_clk;
   // UART Programmer Pinouts
    wire upg_clk, upg_clk_o;
    wire upg_wen_o; //Uart write out enable
    wire upg_done_o; //Uart rx data have done
    //data to which memory unit of program_rom/dmemory32
    wire [14:0] upg_adr_o;
    //data to program_rom or dmemory32
    wire [31:0] upg_dat_o; 
    
    wire start_pg;
    wire spg_bufg;
    parameter son=3'b100, soff=3'b101;
    reg[2:0] state_uart,nxt_uart;
    
    always @* begin //fsms
    if(fpga_rst)
        state_uart <= soff;
    else
        state_uart <= nxt_uart;
    end
    
    always @* begin //fsm-uart
    case(state_uart)
        soff: if(btn[5]) nxt_uart=son;
        son: if(btn[5]) nxt_uart=soff;
        default: nxt_uart=state_uart;
    endcase
    end
    BUFG U1(.I(start_pg), .O(spg_bufg)); // de-twitter
    // Generate UART Programmer reset signal
    reg upg_rst;
    always @ (posedge fpga_clk) begin
        if (spg_bufg) upg_rst = 0;
        if (fpga_rst) upg_rst = 1;
    end
    //used for other modules which don't relate to UART
    wire rst;
    assign rst = fpga_rst | !upg_rst;
    cpuclk cclk(.clk_in1(fpga_clk),.clk_out1(cpu_clk),.clk_out2(upg_clk));
    wire upg_tx_o;//useless
    uart_bmpg_0 uart(.upg_clk_i(upg_clk),.upg_rst_i(upg_rst),.upg_rx_i(rx),.upg_clk_o(upg_clk_o),
     .upg_wen_o(upg_wen_o),.upg_adr_o(upg_adr_o),.upg_dat_o(upg_dat_o),.upg_done_o(upg_done_o),.upg_tx_o(upg_tx_o));
    
    
    
    //input部分
    reg [2:0] state,next_state;
    parameter s0=3'b000, s1=3'b001, s2=3'b010, s3=3'b011 ,s4=3'b100; //s0等待输入case //s1输入case完成 //s2输入input1 s3 输入input2完成 展示中  //s4开始执行
    reg [2:0] cases;
    reg [7:0] ioread_data_switch;

    
    always @* begin //fsms
        if(fpga_rst)
            state <= s1;
        else
            state <= next_state;
    end
    
    always @* begin //fsm-detail
        case(state)
            s0:if(case_yes) begin next_state = s1; cases={switch[2:0]}; end //输入测试样例
                else next_state=s0;
            s1:if(input_yes) begin next_state=s2; ioread_data_switch=switch; end // 输入参数1
                else begin next_state=s1; ioread_data_switch=ioread_data_switch; end
            s2:if(input_yes) begin next_state=s3; ioread_data_switch=switch; end // 输入参数2--有些测试场景要考虑一下比如只有一个输入 第二个输入会直接按按钮啥的 这个时候就别搞辣么多啥的
                else begin next_state=s2; ioread_data_switch=ioread_data_switch; end
            s3:if(start) next_state=s4;   //展示一下输入的数（有必要的话） 
               else next_state=s3;
            s4:if(switch_case) next_state=s0;   //测试场景结束 切换 
               else next_state=s4;
            default: next_state=next_state;
        endcase
    end
    
   
   
   wire [31:0] ALU_Result,Read_data_1,Read_data_2,Sign_extend,Addr_Result,branch_base_addr,link_addr,write_data;
   wire [31:0] addr_out,m_rdata,r_wdata,r_rdata;
   wire [7:0] ior_data;
   wire [1:0] ALUOp;
   wire ALUSrc,I_format,Sftmd,Zero,Branch,nBranch,Jmp,Jal,Jr,RegDST,MemorIOtoReg,RegWrite,MemWrite,MemRead,IORead,IOWrite;
   wire LEDCtrl,switchctrl,segctrl,btnctrl;
    
    wire[31:0] Instruction_i,Instruction_o;//要注意rst的什么电平有效 高电平high-effective
    wire[13:0] rom_adr_o;
    
    programrom pgr(cpu_clk,rom_adr_o,Instruction_i,upg_rst,upg_clk_o,upg_wen_o,upg_adr_o[13:0],upg_dat_o,upg_done_o);
    IFetc32 iff(Instruction_o, branch_base_addr,  Addr_Result, Read_data_1, Branch, nBranch, Jmp, Jal, Jr, Zero,cpu_clk, fpga_rst,link_addr,rom_adr_o,Instruction_i);

    Controller ucc(Instruction_o[31:26],(Instruction_o[5:0]) ,ALU_Result[31:10],Jr,RegDST,ALUSrc,MemorIOtoReg,RegWrite,MemWrite,MemRead,Branch,
                    nBranch,Jmp,Jal,I_format,Sftmd,ALUOp,IORead,IOWrite);

    
    ALU alu(.Read_data_1(Read_data_1),.Read_data_2(Read_data_2),.Sign_extend(Sign_extend),.Function_opcode(Instruction_o[5:0]),.Exe_opcode(Instruction_o[31:26]),.ALUOp(ALUOp),
                .Shamt(Instruction_o[10:6]),.ALUSrc(ALUSrc),.I_format(I_format),.Zero(Zero),.Sftmd(Sftmd),.ALU_Result(ALU_Result),.Addr_Result(Addr_Result),.PC_plus_4(branch_base_addr),
                .Jr(Jr));
        

    MemOrIO mio(MemorIOtoReg,MemWrite,IORead,IOWrite,Addr_Result,
        addr_out,m_rdata,ior_data,r_wdata,Read_data_1,write_data,LEDCtrl,switchctrl,segctrl,btnctrl);
//            input[31:0] r_rdata; // data read from Decoder(register file)//对应readdata1 
//            output reg[31:0] write_data; //data to memory or I/O（m_wdata,io_wdata)

    // input	[7:0]	ledwdata,	// the data (from register/memorio)  waiting for to be writen to the leds of the board
    //wire ledwrite; //led write enable, active high (写信号,高电平有效)
    reg [31:0] segwrite;
    
    //这里有个问题就是到底write哪7个bit进去呢？？？按道理来说 可以根据题目晚上一下大概！！！
    //这里我是用了后七位 比较关系的话 可以给一个东西赋值为1 就可以体现在led上 刚好是最低的bit
    //2的幂和奇数也可以相似的去做 奇数用一个rem 寄存器的值就直接会得到1
    
    //基本测试场景2中 溢出检测也是 比较最高一个bit 存在1在一个寄存器中 体现在LED中！！
    //注意：只能存1！！！比较方便
    leds l(fpga_rst,fpga_clk,IOWrite,LEDCtrl,write_data[7:0],ledout);
    ioread ur(fpga_rst,IORead,switchctrl,ioread_data_switch,ior_data);
    segtube st(fpga_clk,fpga_rst,segctrl,segwrite,seg_en,seg_out1,seg_out2);
    
    //addr_out需要是14位长度 
    dmemory32 dm(cpu_clk,MemWrite,addr_out[15:2],write_data,m_rdata,upg_rst,upg_clk_o,upg_wen_o,upg_adr_o[13:0],upg_dat_o,upg_done_o);
    Decoder ude(Read_data_1,Read_data_2,Instruction_o,r_wdata/*mem_data*/,ALU_Result,
                 Jal,RegWrite,MemorIOtoReg,RegDST,Sign_extend,cpu_clk,fpga_rst,link_addr);
    //mem_data  从DATA RAM or I/O port取出的数据
    //        input[31:0] r_rdata; // data read from Decoder(register file)from MEMorIO
    //  m_rdata ->  output [31:0] ram_dat_o, // the data read from data-ram
    
    
    //判断何时改变seg的seg write=write_data；
    reg [27:0] count_2s;
    reg [28:0] count_5s;
    wire temp_2s;
    wire temp_5s;
    assign temp_2s = ((segctrl&&cases==3'b010)||(segctrl&&cases==3'b011));
    assign temp_5s = (segctrl&&cases==3'b111);
    always@(posedge fpga_clk) begin //count 2s   用于实现每2-3s 一变 
        if(temp_2s) begin
            if(count_2s == 28'd200000000)
            count_2s <= 0;
        else
            count_2s <= count_2s + 1;
        end
        else 
            count_2s <= 0;
    end   
   
    always@(posedge fpga_clk) begin //count 5s   用于实现每5s 一变 
        if(temp_5s) begin
            if(count_5s == 29'd500000000)
            count_5s <= 0;
            else
                count_5s <= count_5s + 1;
        end
        else 
            count_5s <= 0;
    end   
    
    always@(posedge fpga_clk) begin//使用case和计时器来控制每次输出参数停留2s或5s
        casex({state,cases})
            6'b000_xxx: segwrite={32'h0000_0001}; 
            6'b001_xxx: segwrite={28'h0000_000,1'b0,cases};//刚输入完测试样例-cases3bit
            6'b010_xxx: segwrite={24'h000000,ioread_data_switch}; //ioread_data_switch 8bit 第一次输入
            6'b011_xxx: segwrite={24'h000000,ioread_data_switch};//ioread_data_switch 8bit 第二次输入
            6'b100_01x: begin if(count_2s == 28'd200000000) segwrite=write_data; end
            6'b100_111: begin if(count_5s == 29'd500000000) segwrite=write_data; end
            default: segwrite=write_data;
        endcase
    end   

endmodule
