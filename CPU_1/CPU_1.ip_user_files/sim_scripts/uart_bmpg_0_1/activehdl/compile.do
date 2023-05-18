vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm

vlog -work xil_defaultlib  -sv2k12 \
"C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../CPU_1.srcs/sources_1/ip/uart_bmpg_0_1/uart_bmpg.v" \
"../../../../CPU_1.srcs/sources_1/ip/uart_bmpg_0_1/upg.v" \
"../../../../CPU_1.srcs/sources_1/ip/uart_bmpg_0_1/sim/uart_bmpg_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

