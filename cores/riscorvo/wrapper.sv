module rvfi_wrapper (
	input         clock,
	input         reset,
	`RVFI_OUTPUTS
);
	(* keep *) wire        valid_instr;
	(* keep *) wire [31:0] addr_instr;
	(* keep *) `rvformal_rand_reg        ready_instr;
	(* keep *) `rvformal_rand_reg [31:0] data_instr;

	(* keep *) wire        valid_data;
	(* keep *) wire [31:0] addr_data;
	(* keep *) wire [31:0] write_data;
	(* keep *) wire read_write;
	(* keep *) wire [3:0] mask_data;
	(* keep *) `rvformal_rand_reg        ready_data;
	(* keep *) `rvformal_rand_reg [31:0] read_data;

	riscorvo_top #(
		.FIFO_SLOTS(2),
		.RESET_ADDRESS(32'd0000_0000)
	) uut (
		.clk(clock),
		.reset_n(!reset),
		// Instruction memory interface
		.valid_instr_o(valid_instr),
		.ready_instr_i(ready_instr),
		.data_instr_i(data_instr),
		.addr_instr_o(addr_instr),
		// Data memory interface
		.valid_data_o(valid_data),
		.ready_data_i(ready_data),
		.addr_data_o(addr_data),
		.write_data_o(write_data),
		.read_write_o(read_write),
		.mask_data_o(mask_data),
		.read_data_i(read_data),
		`RVFI_CONN
	);

endmodule

