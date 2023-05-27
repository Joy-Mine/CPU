# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a35tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.cache/wt [current_project]
set_property parent.project_path C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths c:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/ip/SEU_CSE_507_user_uart_bmpg_1.3 [current_project]
set_property ip_output_repo c:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/ip/RAM/dmem32.coe
add_files C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/ip/prgrom/prgmip32.coe
read_verilog -library xil_defaultlib {
  C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/new/ALU.v
  C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/new/Controller.v
  C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/new/Decoder.v
  C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/new/IFetc32.v
  C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/new/MemOrIO.v
  C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/new/dmemory32.v
  C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/new/ioread.v
  C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/new/leds.v
  C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/new/programrom.v
  C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/new/segtube.v
  C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/new/Top.v
}
read_ip -quiet C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/ip/uart_bmpg_0_1/uart_bmpg_0.xci

read_ip -quiet C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/ip/RAM_1/RAM.xci
set_property used_in_implementation false [get_files -all c:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/ip/RAM_1/RAM_ooc.xdc]

read_ip -quiet C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/ip/prgrom_1/prgrom.xci
set_property used_in_implementation false [get_files -all c:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/ip/prgrom_1/prgrom_ooc.xdc]

read_ip -quiet C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/ip/cpuclk_2/cpuclk.xci
set_property used_in_implementation false [get_files -all c:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/ip/cpuclk_2/cpuclk_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/ip/cpuclk_2/cpuclk.xdc]
set_property used_in_implementation false [get_files -all c:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/sources_1/ip/cpuclk_2/cpuclk_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/constrs_1/new/c.xdc
set_property used_in_implementation false [get_files C:/Users/gmcc/Desktop/CPU_1_sssw/CPU_1/CPU_1.srcs/constrs_1/new/c.xdc]


synth_design -top Top -part xc7a35tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef Top.dcp
create_report "synth_2_synth_report_utilization_0" "report_utilization -file Top_utilization_synth.rpt -pb Top_utilization_synth.pb"
