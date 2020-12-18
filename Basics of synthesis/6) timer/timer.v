module timer #(
parameter seconds = 50_000_000
)
(input clk, input rst, output[9:0] out);

reg [9:0] out_reg, out_next;
integer cnt_reg, cnt_next;

assign out = out_reg;

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		out_reg <= 10'h000;
		cnt_reg <= 0;
	end
	else begin
		out_reg <= out_next;
		cnt_reg <= cnt_next;
	end
end

always @(*) begin
	cnt_next = cnt_reg;
	out_next = out_reg;
	
	if(cnt_next == seconds) begin
		cnt_next = 0;
		out_next = out_reg + 1'b1;
	end
	else cnt_next = cnt_reg + 1'b1;
end
endmodule