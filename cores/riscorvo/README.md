
RISC-V Formal proofs for **RISCoRVo**
================================

Quickstart guide:

First install Yosys, SymbiYosys, and the solvers. See
[here](http://symbiyosys.readthedocs.io/en/latest/quickstart.html#installing)
for instructions.  Then download the core, generate the formal checks and run them:

```
git submodule init
git submodule update
chmod +x start_formal.sh debug.sh
./start_formal.sh
```

After to check if the tests are passing you can run the shell script WITHOUT arguments that'll list which tests passed and which don't:

```
./debug.sh
# [FAIL] List of test that FAIL during the tests:
# insn_c_bnez_ch0
# 
# [PASS] List of test that PASSED during the tests:
# insn_c_jalr_ch0
# causal_ch0
# insn_c_addi16sp_ch0
# liveness_ch0
# insn_c_and_ch0
# insn_blt_ch0
```

Then you can run the same script to see the output log and also the VCD with the waveforms that are wrong with:

```
./debug.sh insn_c_bnez_ch0
```

To run individual tests you can specify just the SymbiYosys script like this:

```
sby checks/insn_lw_ch0.sby 
```