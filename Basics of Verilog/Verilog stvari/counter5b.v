module register(clk, rst, inc, dec, ld, in, out);

input clk, rst, inc, dec, ld;
input [5:0] in;
output reg [5:0] out;

reg [5:0] helper;

always @(posedge clk, negedge rst) 
	if(!rst)
		out<=6'b000000;
	else 
		out<=helper;

always @(out,in,inc,dec,ld) begin
	helper = out;
	if(ld) helper = in;
	else if(inc) helper = helper + 8'b00000001;
	else if(dec) helper = helper - 8'b00000001;
end

endmodule
