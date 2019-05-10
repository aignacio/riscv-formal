module rvfi_wrapper (
	input         clock,
	input         reset,
	`RVFI_OUTPUTS
);
	(* keep *) wire trap;

	(* keep *) `rvformal_rand_reg mem_ready;
	(* keep *) `rvformal_rand_reg [31:0] mem_rdata;

	(* keep *) wire        mem_valid;
	(* keep *) wire        mem_instr;
	(* keep *) wire [31:0] mem_addr;
	(* keep *) wire [31:0] mem_wdata;
	(* keep *) wire [3:0]  mem_wstrb;

	picorv32 #(
		.COMPRESSED_ISA(1),
		.ENABLE_FAST_MUL(1),
		.ENABLE_DIV(1),
		.BARREL_SHIFTER(1)
	) uut (
		.clk       (clock    ),
		.resetn    (!reset   ),
		.trap      (trap     ),

		.mem_valid (mem_valid),
		.mem_instr (mem_instr),
		.mem_ready (mem_ready),
		.mem_addr  (mem_addr ),
		.mem_wdata (mem_wdata),
		.mem_wstrb (mem_wstrb),
		.mem_rdata (mem_rdata),

		`RVFI_CONN
	);
	riscorvo_top #(
		.FIFO_SLOTS(8),
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
		.read_data_i(read_data)
	);


`ifdef PICORV32_FAIRNESS
	reg [2:0] mem_wait = 0;
	always @(posedge clock) begin
		mem_wait <= {mem_wait, mem_valid && !mem_ready};
		restrict(~mem_wait || trap);
	end
`endif
endmodule

