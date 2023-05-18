vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm

vlog -work xil_defaultlib -64 -sv \
"C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -64 -93 \
"C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 \
"../../../../CPU_1.srcs/sources_1/ip/uart_bmpg_0_1/uart_bmpg.v" \
"../../../../CPU_1.srcs/sources_1/ip/uart_bmpg_0_1/upg.v" \
"../../../../CPU_1.srcs/sources_1/ip/uart_bmpg_0_1/sim/uart_bmpg_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

