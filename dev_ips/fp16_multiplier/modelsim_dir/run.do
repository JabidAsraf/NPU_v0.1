project open fp16_multiplier.mpf
set PrefMain(file) transcript_new_sim
project compileall
vsim work.tb_fm_seq
run -all
exit
