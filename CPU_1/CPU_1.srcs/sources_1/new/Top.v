`timescale 1ns / 1ps

module Top(
    input fpga_rst, //Active High
    input fpga_clk,
    input[7:0] switch,
    input[4:0] btn,
    // UART Programmer Pinouts
    // start Uart communicate at high level
    input start_pg,
    input rx,
    
    output [7:0] seg_out1,
    output [7:0] seg_out2,
    output [7:0] seg_en,
    output [7:0] ledout,// from leds
    output tx
    );
    
    wire [2:0] num;//�������
    wire [7:0] in;//8�����뿪��
    wire case_yes;
    wire input1_yes;//ȷ�ϵ�һ������
    wire input2_yes;//ȷ�ϵڶ�������
    wire switch_case;
    
    assign case_yes=btn[0];
    assign input1_yes=btn[1];
    assign input2_yes=btn[2];
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
    
    wire spg_bufg;
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
    
    
    
    //input����
    reg [3:0] state,next_state;
    parameter s0=3'b000, s1=3'b001, s2=3'b010, s3=011; //s0�ȴ�����case //s1����case��� //s2����input1 s3 ����input2
    reg [2:0] cases;
    reg [7:0] input1,input2;

    
    always @* begin //fsms
        if(fpga_rst)
            state <= s1;
        else
            state <= next_state;
    end
    
    always @* begin //fsm-detail
        case(state)
            s0:if(case_yes) begin next_state = s1; cases=num; end //�����������
                else next_state=s0;
            s1:if(input1_yes) begin next_state=s2; input1=in; end // �������1
                else begin next_state=s1; input1=input1; end
            s2:if(input2_yes) begin next_state=s3; input2=in; end // �������2
                else begin next_state=s2; input2=input2; end
            s3:if(switch_case) next_state=s0;   //���Գ������� �л� 
                else next_state=s3;
            default: next_state=next_state;
        endcase
    end
    
   
   
   wire [31:0] ALU_Result,Read_data_1,Read_data_2,Sign_extend,Addr_Result,branch_base_addr,link_addr,write_data;
   wire [31:0] addr_out,m_rdata,r_wdata,r_rdata;
   wire [15:0] ioread_data_switch,ior_data;
   wire [1:0] ALUOp;
   wire ALUSrc,I_format,Sftmd,Zero,Branch,nBranch,Jmp,Jal,Jr,RegDST,MemorIOtoReg,RegWrite,MemWrite,MemRead,IORead,IOWrite;
   wire LEDCtrl,switchctrl,segctrl,btnctrl;

    assign ioread_data_switch={input1,input2};
    
    wire[31:0] Instruction_i,Instruction_o;//Ҫע��rst��ʲô��ƽ��Ч mini�����ǵ͵�ƽeffective ?  in code-high
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
//            input[31:0] r_rdata; // data read from Decoder(register file)//��Ӧreaddata1 
//            output reg[31:0] write_data; //data to memory or I/O��m_wdata,io_wdata)

    // input	[7:0]	ledwdata,	// the data (from register/memorio)  waiting for to be writen to the leds of the board
    //wire ledwrite; //led write enable, active high (д�ź�,�ߵ�ƽ��Ч)
    reg [31:0] segwrite;
    
    //�����и�������ǵ���write��7��bit��ȥ�أ�������������˵ ���Ը�����Ŀ����һ�´�ţ�����
    //�����������˺���λ �ȽϹ�ϵ�Ļ� ���Ը�һ��������ֵΪ1 �Ϳ���������led�� �պ�����͵�bit
    //2���ݺ�����Ҳ�������Ƶ�ȥ�� ������һ��rem �Ĵ�����ֵ��ֱ�ӻ�õ�1
    
    //�������Գ���2�� ������Ҳ�� �Ƚ����һ��bit ����1��һ���Ĵ����� ������LED�У���
    //ע�⣺ֻ�ܴ�1�������ȽϷ���
    leds l(fpga_rst,fpga_clk,IOWrite,LEDCtrl,Addr_Result[1:0],write_data[7:0],ledout);
    ioread ur(fpga_rst,IORead,switchctrl,ioread_data_switch,ior_data);
    segtube st(fpga_clk,fpga_rst,segctrl,segwrite,seg_en,seg_out1,seg_out2);
    
    //addr_out��Ҫ��14λ���� 
    dmemory32 dm(cpu_clk,MemWrite,addr_out[15:2],write_data,m_rdata,upg_rst,upg_clk_o,upg_wen_o,upg_adr_o[13:0],upg_dat_o,upg_done_o);
    Decoder ude(Read_data_1,Read_data_2,Instruction_o,r_wdata/*mem_data*/,ALU_Result,
                 Jal,RegWrite,MemorIOtoReg,RegDST,Sign_extend,cpu_clk,fpga_rst,link_addr);
    //mem_data  ��DATA RAM or I/O portȡ��������
    //        input[31:0] r_rdata; // data read from Decoder(register file)from MEMorIO
    //  m_rdata ->  output [31:0] ram_dat_o, // the data read from data-ram
    
    
    //�жϺ�ʱ�ı�seg��seg write=write_data��
    reg [27:0] count_2s;
    reg [28:0] count_5s;
    wire temp_2s;
    wire temp_5s;
    assign temp_2s = ((segctrl&&num==3'b010)||(segctrl&&num==3'b011));
    assign temp_5s = (segctrl&&num==3'b111);
    always@(posedge fpga_clk) begin //count 2s   ����ʵ��ÿ2-3s һ�� 
        if(temp_2s) begin
            if(count_2s == 28'd200000000)
            count_2s <= 0;
        else
            count_2s <= count_2s + 1;
        end
        else 
            count_2s <= 0;
    end   
   
    always@(posedge fpga_clk) begin //count 5s   ����ʵ��ÿ5s һ�� 
        if(temp_5s) begin
            if(count_5s == 29'd500000000)
            count_5s <= 0;
            else
                count_5s <= count_5s + 1;
        end
        else 
            count_5s <= 0;
    end   
    
    always@(posedge fpga_clk) begin//ʹ��case�ͼ�ʱ��������ÿ���������ͣ��2s��5s
        casex(num)
            3'b01x: begin if(count_2s == 28'd200000000) segwrite=write_data; end
            3'b111: begin if(count_5s == 29'd500000000) segwrite=write_data; end
            default: segwrite=segwrite;
        endcase
    end   

endmodule