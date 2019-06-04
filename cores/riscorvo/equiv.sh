#!/bin/bash
set -ex
yosys -p '
	read_verilog riscorvo/src/alu_unit.v
	read_verilog riscorvo/src/branch_unit.v
	read_verilog riscorvo/src/control_unit.v
	read_verilog riscorvo/src/data_interface.v
	read_verilog riscorvo/src/dec_unit.v
	read_verilog riscorvo/src/exec_unit.v
	read_verilog riscorvo/src/fetch_unit.v
	read_verilog riscorvo/src/forward_unit.v
	read_verilog riscorvo/src/hazard_unit.v
	read_verilog riscorvo/src/imm_gen.v
	read_verilog riscorvo/src/mem_unit.v
	read_verilog riscorvo/src/prefetch_fifo.v
	read_verilog riscorvo/src/register_file.v
	read_verilog riscorvo/src/riscorvo_top.v
	read_verilog riscorvo/src/wb_unit.v
	chparam -set ENABLE_MISALIGN_ADDR 0 riscorvo_top
	prep -flatten -top riscorvo_top
	design -stash gold

	read_verilog riscorvo/src/alu_unit.v
	read_verilog riscorvo/src/branch_unit.v
	read_verilog riscorvo/src/control_unit.v
	read_verilog riscorvo/src/data_interface.v
	read_verilog riscorvo/src/dec_unit.v
	read_verilog riscorvo/src/exec_unit.v
	read_verilog riscorvo/src/fetch_unit.v
	read_verilog riscorvo/src/forward_unit.v
	read_verilog riscorvo/src/hazard_unit.v
	read_verilog riscorvo/src/imm_gen.v
	read_verilog riscorvo/src/mem_unit.v
	read_verilog riscorvo/src/prefetch_fifo.v
	read_verilog riscorvo/src/register_file.v
	read_verilog -D RISCV_FORMAL riscorvo/src/riscorvo_top.v
	read_verilog riscorvo/src/wb_unit.v
	chparam -set ENABLE_MISALIGN_ADDR 0 riscorvo_top
	prep -flatten -top riscorvo_top
	delete -port riscorvo_top/rvfi_*
	design -stash gate

'
