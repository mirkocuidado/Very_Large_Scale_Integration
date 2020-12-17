module debouncer (
	input clk,
	input rst_n,
	input in,
	output out
);

reg ff1_reg, ff1_next;
reg ff2_reg, ff2_next;
reg out_reg, out_next;
integer cnt_reg, cnt_next;

wire input_stable;
assign input_stable = (cnt_reg >= 256) ? 1'b1 : 1'b0;
assign out = out_reg; 

always @(posedge clk, negedge rst_n)
	if (!rst_n) begin
		ff1_reg <= 1'b0;
		ff2_reg <= 1'b0;
		out_reg <= 1'b0;
		cnt_reg <= 0;
	end
	else begin
		ff1_reg <= ff1_next;
		ff2_reg <= ff2_next;
		out_reg <= out_next;
		cnt_reg <= cnt_next;
	end
	
always @(*) begin
	ff1_next = in;
	ff2_next = ff1_reg;
	cnt_next = cnt_reg;
	out_next = out_reg;
	cnt_next = (ff1_reg ^ ff1_reg) ? 0 : (cnt_reg + 1);
	out_next = (input_stable == 1'b1) ? ff2_reg : out_reg;
end

endmodule