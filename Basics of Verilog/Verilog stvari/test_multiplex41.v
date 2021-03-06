module test_multiplex41;

reg clk, rst, dec, inc, ld;
reg [5:0] in;
wire [5:0] outt;

wire outmpx;

register register(.clk(clk), .rst(rst), .dec(dec), .inc(inc), .ld(ld), .in(in), .out(outt));

reg [1:0] pom;

multiplex41 m41(.out(outmpx), .in0(outt[2]), .in1(outt[3]), .in2(outt[4]), .in3(outt[4]), .s({outt[0], outt[1]}));

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
	$monitor("TIME=%0d , OUT=%b",$time,outt);

always
	#4 clk = ~clk;


endmodule
