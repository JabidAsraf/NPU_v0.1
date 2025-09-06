onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_fm_err_chk/clk
add wave -noupdate /tb_fm_err_chk/reset_b
add wave -noupdate /tb_fm_err_chk/a
add wave -noupdate /tb_fm_err_chk/b
add wave -noupdate /tb_fm_err_chk/start
add wave -noupdate /tb_fm_err_chk/clear
add wave -noupdate /tb_fm_err_chk/valid
add wave -noupdate /tb_fm_err_chk/out
add wave -noupdate /tb_fm_err_chk/max_err
add wave -noupdate /tb_fm_err_chk/multi_op/float_a
add wave -noupdate /tb_fm_err_chk/multi_op/float_b
add wave -noupdate /tb_fm_err_chk/multi_op/exp
add wave -noupdate /tb_fm_err_chk/multi_op/act
add wave -noupdate /tb_fm_err_chk/multi_op/err
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {6901 ps}
