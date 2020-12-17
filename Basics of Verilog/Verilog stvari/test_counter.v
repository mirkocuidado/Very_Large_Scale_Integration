module test_coutner;

reg clk, rst, dec, inc, ld;
reg [5:0] in;
wire [5:0] out;

register register(.clk(clk), .rst(rst), .dec(dec), .inc(inc), .ld(ld), .in(in), .out(out));

initial begin
	rst = 1'b0;
	clk = 1'b1;
	#2 rst = 1'b1;
	
	repeat(100) begin
		ld = $urandom%2;
		inc = $urandom%2;
		dec = $urandom%2;
		in = $urandom_range(63,0);
		#5;
	end

	#10 $stop;
end

initial 
	$monitor("TIME=%0d , OUT=%b",$time,out);

always
	#4 clk = ~clk;


endmodule
