module reg8(input clk, input rst, input[7:0] in, input ld, input inc, output[7:0] out);

reg [7:0] out_next;
reg [7:0] out_reg;

assign out = out_reg;

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		out_reg <= 8'h00;
	end
	else begin
		out_reg <= out_next;
	end
end

always @(ld, inc) begin

	out_next = out_reg;
	if(ld) out_next = in;
	else if(inc) out_next = out_reg + 1'b1;
	
end

endmodule