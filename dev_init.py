import os
import argparse

sim_var = 0

parser = argparse.ArgumentParser(prog='dev_init.py', description='start the dev environment')
parser.add_argument("-sim", type=int, help="specify whether the proccess runs the simulation ## 0: NO ## 1: YES ## default is NO")

args     = parser.parse_args()

sim_var  = args.sim

os.system ('gvim -p rtl/*.v tb/*.sv sim/*.py sim/*.do');

if sim_var:
    print("\n\n$run_simulaion: True\nStarting modelsim...\n")
    os.system ('python3.10 sim/run.py -test 1 -mode 0');
else:
    print("\n\n$run_simulation: False\nEnvironment set!\n")