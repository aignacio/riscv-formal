#!/bin/bash
cat ./checks/$1/engine_0/logfile.txt
python3 disasm.py ./checks/$1/engine_0/trace.vcd
gtkwave ./checks/$1/engine_0/trace.vcd checks.gtkw
