onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fp16_divider_tb/clk
add wave -noupdate /fp16_divider_tb/reset_b
add wave -noupdate /fp16_divider_tb/a
add wave -noupdate /fp16_divider_tb/b
add wave -noupdate /fp16_divider_tb/start
add wave -noupdate /fp16_divider_tb/valid
add wave -noupdate /fp16_divider_tb/out
add wave -noupdate -divider {Float display}
add wave -noupdate /fp16_divider_tb/div_op/float_a
add wave -noupdate /fp16_divider_tb/div_op/float_b
add wave -noupdate /fp16_divider_tb/div_op/exp
add wave -noupdate /fp16_divider_tb/div_op/act
add wave -noupdate /fp16_divider_tb/div_op/err
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1 ns}
