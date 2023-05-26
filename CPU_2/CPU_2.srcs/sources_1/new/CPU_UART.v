//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Sat May 22 08:04:20 2021
//Host        : LAPTOP-3BOJKTDH running 64-bit major release  (build 9200)
//Command     : generate_target CPUdesign_1.bd
//Design      : CPUdesign_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "CPUdesign_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=CPUdesign_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=16,numReposBlks=16,numNonXlnxBlks=1,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=14,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "CPUdesign_1.hwdef" *) 
module CPU_UART
   (DIG,
    Y,
    fpga_clk,
    fpga_rst,
    i_row,
    led,
    o_col,
    start_pg,
    switch,
    upg_rx,
    upg_tx);
  output [7:0]DIG;
  output [7:0]Y;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.FPGA_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.FPGA_CLK, CLK_DOMAIN CPUdesign_1_fpga_clk, FREQ_HZ 100000000, PHASE 0.000" *) input fpga_clk;
  input fpga_rst;
  input [3:0]i_row;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.LED DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.LED, LAYERED_METADATA undef" *) output [23:0]led;
  output [3:0]o_col;
  input start_pg;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.SWITCH DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.SWITCH, LAYERED_METADATA undef" *) input [23:0]switch;
  input upg_rx;
  output upg_tx;

  wire [31:0]Executs32_0_ALU_Result;
  wire [21:0]Executs32_0_ALU_ResultHigh;
  wire [31:0]Executs32_0_Addr_Result;
  wire Executs32_0_Zero;
  wire [31:0]Idecode32_0_imme_extend;
  wire [31:0]Idecode32_0_read_data_1;
  wire [31:0]Idecode32_0_read_data_2;
  wire [31:0]Ifetc32_0_Instruction;
  wire [31:0]Ifetc32_0_branch_base_addr;
  wire [5:0]Ifetc32_0_func;
  wire [31:0]Ifetc32_0_link_addr;
  wire [5:0]Ifetc32_0_opcode;
  wire [13:0]Ifetc32_0_rom_adr_o;
  wire [4:0]Ifetc32_0_shamt;
  wire MemoryOrIO_0_BoardCtrl;
  wire MemoryOrIO_0_LEDCtrl;
  wire MemoryOrIO_0_SegCtrl;
  wire MemoryOrIO_0_SwitchCtrl;
  wire [31:0]MemoryOrIO_0_addr_out;
  wire [15:0]MemoryOrIO_0_ledLowData;
  wire [1:0]MemoryOrIO_0_lowAddr;
  wire [31:0]MemoryOrIO_0_r_wdata;
  wire [31:0]MemoryOrIO_0_write_data;
  wire clk_wiz_0_clk_out1;
  wire clk_wiz_0_clk_out2;
  wire clk_wiz_0_clk_out3;
  wire [1:0]control32_0_ALUOp;
  wire control32_0_ALUSrc;
  wire control32_0_Branch;
  wire control32_0_IORead;
  wire control32_0_IOWrite;
  wire control32_0_I_format;
  wire control32_0_Jal;
  wire control32_0_Jmp;
  wire control32_0_Jr;
  wire control32_0_MemRead;
  wire control32_0_MemWrite;
  wire control32_0_MemtoReg;
  wire control32_0_RegDST;
  wire control32_0_RegWrite;
  wire control32_0_Sftmd;
  wire control32_0_nBranch;
  wire debounce_0_led;
  wire debounce_1_led;
  wire [31:0]dmemory32_0_read_data;
  wire fpga_clk_1;
  wire fpga_rst_1;
  wire [3:0]i_row_1;
  wire [23:0]leds_0_ledout;
  wire [15:0]matrixKeyboard_drive_0_boarddata;
  wire [3:0]matrixKeyboard_drive_0_col;
  wire process_0_rst;
  wire process_0_upg_rst;
  wire [31:0]programrom_0_Instruction_o;
  wire [7:0]seg_0_DIG;
  wire [7:0]seg_0_Y;
  wire start_pg_1;
  wire [23:0]switch_1;
  wire [15:0]switchs_0_switchrdata;
  wire [14:0]uart_bmpg_0_upg_adr_o;
  wire uart_bmpg_0_upg_clk_o;
  wire [31:0]uart_bmpg_0_upg_dat_o;
  wire uart_bmpg_0_upg_done_o;
  wire uart_bmpg_0_upg_tx_o;
  wire uart_bmpg_0_upg_wen_o;
  wire upg_rx_1;

  assign DIG[7:0] = seg_0_DIG;
  assign Y[7:0] = seg_0_Y;
  assign fpga_clk_1 = fpga_clk;
  assign fpga_rst_1 = fpga_rst;
  assign i_row_1 = i_row[3:0];
  assign led[23:0] = leds_0_ledout;
  assign o_col[3:0] = matrixKeyboard_drive_0_col;
  assign start_pg_1 = start_pg;
  assign switch_1 = switch[23:0];
  assign upg_rx_1 = upg_rx;
  assign upg_tx = uart_bmpg_0_upg_tx_o;
  ALU Executs32_0
       (.ALUOp(control32_0_ALUOp),
        .ALUSrc(control32_0_ALUSrc),
        .ALU_Result(Executs32_0_ALU_Result),
        .ALU_ResultHigh(Executs32_0_ALU_ResultHigh),
        .Addr_Result(Executs32_0_Addr_Result),
        .Function_opcode(Ifetc32_0_func),
        .I_format(control32_0_I_format),
        .Imme_extend(Idecode32_0_imme_extend),
        .Jr(control32_0_Jr),
        .PC_plus_4(Ifetc32_0_branch_base_addr),
        .Read_data_1(Idecode32_0_read_data_1),
        .Read_data_2(Idecode32_0_read_data_2),
        .Sftmd(control32_0_Sftmd),
        .Shamt(Ifetc32_0_shamt),
        .Zero(Executs32_0_Zero),
        .opcode(Ifetc32_0_opcode));
  Decoder Idecode32_0
       (.ALU_result(Executs32_0_ALU_Result),
        .Instruction(Ifetc32_0_Instruction),
        .Jal(control32_0_Jal),
        .MemtoReg(control32_0_MemtoReg),
        .RegDst(control32_0_RegDST),
        .RegWrite(control32_0_RegWrite),
        .clock(clk_wiz_0_clk_out1),
        .imme_extend(Idecode32_0_imme_extend),
        .opcplus4(Ifetc32_0_link_addr),
        .read_data(MemoryOrIO_0_r_wdata),
        .read_data_1(Idecode32_0_read_data_1),
        .read_data_2(Idecode32_0_read_data_2),
        .reset(process_0_rst));
  IFetch_UART Ifetc32_0
       (.Addr_result(Executs32_0_Addr_Result),
        .Branch(control32_0_Branch),
        .Instruction_i(programrom_0_Instruction_o),
        .Instruction_o(Ifetc32_0_Instruction),
        .Jal(control32_0_Jal),
        .Jmp(control32_0_Jmp),
        .Jr(control32_0_Jr),
        .Read_data_1(Idecode32_0_read_data_1),
        .Zero(Executs32_0_Zero),
        .branch_base_addr(Ifetc32_0_branch_base_addr),
        .clock(clk_wiz_0_clk_out1),
        .func(Ifetc32_0_func),
        .link_addr(Ifetc32_0_link_addr),
        .nBranch(control32_0_nBranch),
        .opcode(Ifetc32_0_opcode),
        .reset(process_0_rst),
        .rom_adr_o(Ifetc32_0_rom_adr_o),
        .shamt(Ifetc32_0_shamt));
  MemOrIO MemoryOrIO_0
       (.BoardCtrl(MemoryOrIO_0_BoardCtrl),
        .LEDCtrl(MemoryOrIO_0_LEDCtrl),
        .SegCtrl(MemoryOrIO_0_SegCtrl),
        .SwitchCtrl(MemoryOrIO_0_SwitchCtrl),
        .addr_in(Executs32_0_ALU_Result),
        .addr_out(MemoryOrIO_0_addr_out),
        .ioRead(control32_0_IORead),
        .ioWrite(control32_0_IOWrite),
        .io_rdata1(switchs_0_switchrdata),
        .io_rdata2(matrixKeyboard_drive_0_boarddata),
        .ledLowData(MemoryOrIO_0_ledLowData),
        .lowAddr(MemoryOrIO_0_lowAddr),
        .mRead(control32_0_MemRead),
        .mWrite(control32_0_MemWrite),
        .m_rdata(dmemory32_0_read_data),
        .r_rdata(Idecode32_0_read_data_2),
        .r_wdata(MemoryOrIO_0_r_wdata),
        .write_data(MemoryOrIO_0_write_data));
  clk_wiz_0 clk_wiz_0_1
       (.clk_in1(fpga_clk_1),
        .clk_out1(clk_wiz_0_clk_out1),
        .clk_out2(clk_wiz_0_clk_out2),
        .clk_out3(clk_wiz_0_clk_out3));
  ControllerIO control32_0
       (.ALUOp(control32_0_ALUOp),
        .ALUSrc(control32_0_ALUSrc),
        .Alu_resultHigh(Executs32_0_ALU_ResultHigh),
        .Branch(control32_0_Branch),
        .Function_opcode(Ifetc32_0_func),
        .IORead(control32_0_IORead),
        .IOWrite(control32_0_IOWrite),
        .I_format(control32_0_I_format),
        .Jal(control32_0_Jal),
        .Jmp(control32_0_Jmp),
        .Jr(control32_0_Jr),
        .MemRead(control32_0_MemRead),
        .MemWrite(control32_0_MemWrite),
        .MemorIOtoReg(control32_0_MemtoReg),
        .Opcode(Ifetc32_0_opcode),
        .RegDST(control32_0_RegDST),
        .RegWrite(control32_0_RegWrite),
        .Sftmd(control32_0_Sftmd),
        .nBranch(control32_0_nBranch));
  debounce debounce_0
       (.clk(clk_wiz_0_clk_out2),
        .key(fpga_rst_1),
        .led(debounce_0_led));
  debounce debounce_1
       (.clk(clk_wiz_0_clk_out2),
        .key(start_pg_1),
        .led(debounce_1_led));
  Dmem_UART dmemory32_0
       (.ram_adr_i(MemoryOrIO_0_addr_out),
        .ram_clk_i(clk_wiz_0_clk_out1),
        .ram_dat_i(MemoryOrIO_0_write_data),
        .ram_dat_o(dmemory32_0_read_data),
        .ram_wen_i(control32_0_MemWrite),
        .upg_adr_i(uart_bmpg_0_upg_adr_o),
        .upg_clk_i(uart_bmpg_0_upg_clk_o),
        .upg_dat_i(uart_bmpg_0_upg_dat_o),
        .upg_done_i(uart_bmpg_0_upg_done_o),
        .upg_rst_i(process_0_upg_rst),
        .upg_wen_i(uart_bmpg_0_upg_wen_o));
  LED leds_0
       (.led_clk(clk_wiz_0_clk_out1),
        .ledaddr(MemoryOrIO_0_lowAddr),
        .ledcs(MemoryOrIO_0_LEDCtrl),
        .ledout(leds_0_ledout),
        .ledrst(process_0_rst),
        .ledwdata(MemoryOrIO_0_ledLowData),
        .ledwrite(control32_0_IOWrite));
  matrixKeyboard_drive matrixKeyboard_drive_0
       (.boarddata(matrixKeyboard_drive_0_boarddata),
        .boardread(control32_0_IORead),
        .col(matrixKeyboard_drive_0_col),
        .i_clk(clk_wiz_0_clk_out2),
        .i_rst(process_0_rst),
        .keyboardaddr(MemoryOrIO_0_lowAddr),
        .keyboardcs(MemoryOrIO_0_BoardCtrl),
        .row(i_row_1));
  process process_0
       (.fpga_clk(clk_wiz_0_clk_out2),
        .fpga_rst(debounce_0_led),
        .rst(process_0_rst),
        .start_pg(debounce_1_led),
        .upg_rst(process_0_upg_rst));
  ProgramROM_UART programrom_0
       (.Instruction_o(programrom_0_Instruction_o),
        .rom_adr_i(Ifetc32_0_rom_adr_o),
        .rom_clk_i(clk_wiz_0_clk_out1),
        .upg_adr_i(uart_bmpg_0_upg_adr_o),
        .upg_clk_i(uart_bmpg_0_upg_clk_o),
        .upg_dat_i(uart_bmpg_0_upg_dat_o),
        .upg_done_i(uart_bmpg_0_upg_done_o),
        .upg_rst_i(process_0_upg_rst),
        .upg_wen_i(uart_bmpg_0_upg_wen_o));
  Tubs seg_0
       (.DIG(seg_0_DIG),
        .Y(seg_0_Y),
        .clk(clk_wiz_0_clk_out2),
        .rst(process_0_rst),
        .segaddr(MemoryOrIO_0_lowAddr),
        .segcs(MemoryOrIO_0_SegCtrl),
        .segwdata(MemoryOrIO_0_ledLowData),
        .segwrite(control32_0_IOWrite));
  Switch switchs_0
       (.switch_i(switch_1),
        .switchaddr(MemoryOrIO_0_lowAddr),
        .switchcs(MemoryOrIO_0_SwitchCtrl),
        .switchrdata(switchs_0_switchrdata),
        .switchread(control32_0_IORead),
        .switclk(clk_wiz_0_clk_out1),
        .switrst(process_0_rst));
  uart_bmpg_0 uart_bmpg_0_1
       (.upg_adr_o(uart_bmpg_0_upg_adr_o),
        .upg_clk_i(clk_wiz_0_clk_out3),
        .upg_clk_o(uart_bmpg_0_upg_clk_o),
        .upg_dat_o(uart_bmpg_0_upg_dat_o),
        .upg_done_o(uart_bmpg_0_upg_done_o),
        .upg_rst_i(process_0_upg_rst),
        .upg_rx_i(upg_rx_1),
        .upg_tx_o(uart_bmpg_0_upg_tx_o),
        .upg_wen_o(uart_bmpg_0_upg_wen_o));
endmodule
