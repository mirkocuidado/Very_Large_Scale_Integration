module deb(input clk, input rst, input in, output out);

reg out_reg, out_next;
reg ff1_reg, ff1_next, ff2_reg, ff2_next;

wire in_stable, in_changed;

integer timer_reg, timer_next;

assign out = out_reg;
assign in_changed = ff1_reg ^ ff2_reg;
assign in_stable = (timer_reg == 255) ? 1'b1 : 1'b0;

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		timer_reg <= 0;
		ff1_reg <= 1'b0;
		ff2_reg <= 1'b0;
		out_reg <= 1'b0;
	end
	else begin
		timer_reg <= timer_next;
		ff1_reg <= ff1_next;
		ff2_reg <= ff2_next;
		out_reg <= out_next;
	end
end

always @(*) begin
	ff1_next = in;
	ff2_next = ff1_reg;
	
	timer_next = (in_changed == 1'b1) ? 0 : (timer_reg + 1);
	out_next = (in_stable == 1'b1) ? ff2_reg : out_reg;
	
end
endmodule
