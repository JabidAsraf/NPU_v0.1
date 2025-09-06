onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate /tb/reset_b
add wave -noupdate /tb/a
add wave -noupdate /tb/start
add wave -noupdate /tb/clear
add wave -noupdate /tb/valid
add wave -noupdate /tb/out
add wave -noupdate -divider tb
add wave -noupdate /tb/softmax_op/exp
add wave -noupdate /tb/softmax_op/act
add wave -noupdate /tb/softmax_op/err
add wave -noupdate -format Analog-Step -height 84 -max 7.8285999999999971 -min -18.392700000000001 /tb/softmax_op/err_p
add wave -noupdate /tb/softmax_op/exp_total
add wave -noupdate /tb/softmax_op/act_total
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {976984 ps} 0}
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
WaveRestoreZoom {0 ps} {16490 ps}
