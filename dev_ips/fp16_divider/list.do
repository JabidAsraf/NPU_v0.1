onerror {resume}
add list -width 22 /fp16_divider_tb/clk
add list /fp16_divider_tb/reset_b
add list /fp16_divider_tb/a
add list /fp16_divider_tb/b
add list /fp16_divider_tb/start
add list /fp16_divider_tb/valid
add list /fp16_divider_tb/out
add list /fp16_divider_tb/div_op/float_a
add list /fp16_divider_tb/div_op/float_b
add list /fp16_divider_tb/div_op/exp
add list /fp16_divider_tb/div_op/act
add list /fp16_divider_tb/div_op/err
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta all
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
