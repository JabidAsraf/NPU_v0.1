onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/DUT/clk
add wave -noupdate /tb/DUT/reset_b
add wave -noupdate /tb/DUT/start_op
add wave -noupdate /tb/DUT/clear
add wave -noupdate /tb/DUT/input_neuron_val
add wave -noupdate /tb/DUT/output_neuron_val
add wave -noupdate /tb/DUT/valid
add wave -noupdate /tb/DUT/exp_out
add wave -noupdate /tb/DUT/start_exp
add wave -noupdate /tb/DUT/valid_ind_exp
add wave -noupdate /tb/DUT/valid_exp
add wave -noupdate /tb/DUT/start_addition
add wave -noupdate /tb/DUT/valid_addition
add wave -noupdate /tb/DUT/start_division
add wave -noupdate /tb/DUT/valid_ind_division
add wave -noupdate /tb/DUT/valid_division
add wave -noupdate /tb/DUT/divisor_buff_d
add wave -noupdate /tb/DUT/divisor_buff_q
add wave -noupdate /tb/DUT/adder_buff_d
add wave -noupdate /tb/DUT/adder_buff_q
add wave -noupdate /tb/DUT/add_count
add wave -noupdate /tb/DUT/add_count_match
add wave -noupdate /tb/DUT/adder_out
add wave -noupdate /tb/DUT/clear_exp
add wave -noupdate /tb/DUT/clear_adder
add wave -noupdate /tb/DUT/clear_division
add wave -noupdate /tb/DUT/clear_counter
add wave -noupdate /tb/DUT/vexp_posedge
add wave -noupdate /tb/DUT/vexp_edge_det_temp
add wave -noupdate /tb/DUT/valid_addition_delayed
add wave -noupdate /tb/DUT/pstate
add wave -noupdate /tb/DUT/nstate
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {646 ps}
