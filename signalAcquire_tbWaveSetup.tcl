#################################################################################
# signalAcquire_wave.tcl
# Vivado / XSim waveform setup for signalAcquire_tb
#################################################################################

restart
remove_wave [get_waves *]

add_wave -color green {/signalAcquire_tb/clk_t}
add_wave -color green {/signalAcquire_tb/resetn_t}
add_wave -color green -radix unsigned {/signalAcquire_tb/btn_t}
add_wave -color green -radix hex {/signalAcquire_tb/an7606data_t}
add_wave -color green {/signalAcquire_tb/an7606convst_t}
add_wave -color green {/signalAcquire_tb/an7606cs_t}
add_wave -color green {/signalAcquire_tb/an7606rd_t}
add_wave -color green {/signalAcquire_tb/an7606reset_t}
add_wave -color green -radix unsigned {/signalAcquire_tb/an7606od_t}
add_wave -color green {/signalAcquire_tb/an7606busy_t}

add_wave -color green {/signalAcquire_tb/uut/clk}
add_wave -color green {/signalAcquire_tb/uut/resetn}
add_wave -color green -radix unsigned {/signalAcquire_tb/uut/btn}

add_wave -color aqua {/signalAcquire_tb/uut/cu/state}

add_wave -color purple -radix unsigned {/signalAcquire_tb/uut/dataP/short_cnt}
add_wave -color purple -radix unsigned {/signalAcquire_tb/uut/dataP/long_cnt}
add_wave -color purple -radix unsigned {/signalAcquire_tb/uut/dataP/rf_cnt}

add_wave -color orange -radix hex {/signalAcquire_tb/uut/an7606data}
add_wave -color orange {/signalAcquire_tb/uut/an7606convst}
add_wave -color orange {/signalAcquire_tb/uut/an7606cs}
add_wave -color orange {/signalAcquire_tb/uut/an7606rd}
add_wave -color orange {/signalAcquire_tb/uut/an7606reset}
add_wave -color orange {/signalAcquire_tb/uut/an7606busy}

add_wave -color red -radix hex {/signalAcquire_tb/uut/cw}

add_wave -color red -radix hex {/signalAcquire_tb/uut/sw}
add_wave -color red -radix unsigned -name Trigger {/signalAcquire_tb/uut/sw[3]}

add_wave -color yellow -radix hex {/signalAcquire_tb/uut/dataP/signalRegister/Q0}
add_wave -color yellow -radix hex {/signalAcquire_tb/uut/dataP/signalRegister/Q1}
add_wave -color yellow -radix hex {/signalAcquire_tb/uut/dataP/signalRegister/Q2}