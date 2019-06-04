#!/bin/bash
if [ -z "$1" ]
then    
    echo -e "[ERROR] - No test supplied, you should pass the name of the test as single argument, ex.: \n\n ./debug insn_addi_ch0"
    echo -e "\n\n[FAIL] List of test that FAIL during the tests:"
    cd checks
    find . -name "FAIL" -printf "%h\n" | sed "s|^\./||"
    cd ../
    echo -e "\n\n[PASS] List of test that PASSED during the tests:"
    cd checks
    find . -name "PASS" -printf "%h\n" | sed "s|^\./||" 
    cd ../
else
    cat ./checks/$1/engine_0/logfile.txt
    python3 disasm.py ./checks/$1/engine_0/trace.vcd
    gtkwave ./checks/$1/engine_0/trace.vcd checks.gtkw
fi
