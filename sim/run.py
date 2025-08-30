import os
import argparse

parser = argparse.ArgumentParser(prog='run.py', description='start a simulation of the npu_v2 design', epilog=':)')
parser.add_argument("-test", type=int, help="specify test type ## 0: Full NPU test ## 1: NPU SPI Regiser Interface test")
parser.add_argument("-mode", type=int, help="specify simulation mode ## 0: CLI ## 1: GUI")

args     = parser.parse_args()

test_num = args.test
gong_arg = args.mode 

gong     = "" if (gong_arg == 1) else "-c" 

os.system  ('cd ../');
os.system  ('vsim -c -do "do sim/init.do"');
os.environ["MODE"] = str(gong_arg);
os.environ["TEST_NUM"] = str(test_num);
os.system  ('vsim ' + gong + ' -do "do sim/run.do"');