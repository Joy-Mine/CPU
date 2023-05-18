-makelib ies_lib/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../CPU_1.srcs/sources_1/ip/uart_bmpg_0_1/uart_bmpg.v" \
  "../../../../CPU_1.srcs/sources_1/ip/uart_bmpg_0_1/upg.v" \
  "../../../../CPU_1.srcs/sources_1/ip/uart_bmpg_0_1/sim/uart_bmpg_0.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

