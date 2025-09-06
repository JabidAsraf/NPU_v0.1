read_verilog ../fp16_multiplier.v ../standard_macros.v
synth -top fp16_multiplier
dfflibmap -liberty library.lib
abc -liberty library.lib
clean
write_verilog fp16_multiplier_netlist.v

show fp16_multiplier
