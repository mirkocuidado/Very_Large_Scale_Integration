module rising_edge_detector(input clk, input rst, input in, output out);

reg ff1_reg, ff1_next;
reg ff2_reg, ff2_next;

assign out = ff1_reg & ~ff2_reg;

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		ff1_reg <= 1'b0;
		ff2_reg <= 1'b0;
	end
	else if(clk) begin
		ff1_reg <= ff1_next;
		ff2_reg <= ff2_next;
	end
end

always @(*) begin
	ff1_next = in;
	ff2_next = ff1_reg;
end







endmodule