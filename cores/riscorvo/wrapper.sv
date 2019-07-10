module rvfi_wrapper (
	input         clock,
	input         reset,
	`RVFI_OUTPUTS
);
	(* keep *) wire [31:0] addr_data_mem;
	(* keep *) wire        trap;
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

	localparam MTIME_ADDR = 32'hA000_0000;
	localparam MTIMEH_ADDR = 32'hA000_0004;
	localparam MTIMECMP_ADDR = 32'hA000_0008;
	localparam MTIMECMPH_ADDR = 32'hA000_000C;
	localparam MTIMEDIV_ADDR = 32'hA000_0010;

	riscorvo_top # (
		.FIFO_SLOTS(8),
  		.RESET_ADDRESS(32'h0000_0000),
  		.TRAP_BASE_ADDR(32'h0000_0000),
  		.ENABLE_COMPRESSED_ISA(1),
  		.ENABLE_MULT_DIV_ISA(1),
  		.ENABLE_MISALIGN_ADDR(0),
  		.ENABLE_CUSTOM_ISA(0),
  		.MTIME_ADDR(MTIME_ADDR),
  		.MTIMEH_ADDR(MTIMEH_ADDR),
  		.MTIMECMP_ADDR(MTIMECMP_ADDR),
  		.MTIMECMPH_ADDR(MTIMECMPH_ADDR),
  		.MTIMEDIV_ADDR(MTIMEDIV_ADDR)
	) uut (
		.clk(clock),
		.reset_n(!reset),
		.sync_trap_o(trap),
		.addr_data_mem_o(addr_data_mem),
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

	// Avoid to enter in the MM registers
	always @ (*) begin
		assume(addr_data_mem < 32'hA000_0000);
		assume(ready_instr);
		assume(trap == 1'b0);
	end

`ifdef RISCORVO_FAIRNESS

	reg [2:0] mem_wait = 0;
	always @(posedge clock) begin
		mem_wait <= {mem_wait, valid_data && !ready_data};
		restrict(~mem_wait || trap);
	end
`endif
endmodule

