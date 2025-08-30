set test_num $env(TEST_NUM)
set mode $env(MODE)

set project_name "npu_v2"

project open $project_name
project compileall

if {$mode == 1} {
    vsim work.tb_top -do "run -all" +TEST=$test_num;
} else {
    vsim -c work.tb_top -do "run -all" +TEST=$test_num;
}
