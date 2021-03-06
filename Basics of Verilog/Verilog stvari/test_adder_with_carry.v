module test_adder_with_carry;

reg [3:0] in1, in2;
wire [3:0] out;
reg carry0;

adder_with_carry_for_four_bits a(in1,in2,out,carry0);

initial begin

in1 = 4'b0000;
in2 = 4'b0000;
carry0 = 1'b0;

repeat(15) begin
	#5 carry0 = 1'b1;
	#5 in1 = in1 + 4'b0001;
	#5 in2 = in2 + 4'b0001;
	#5 carry0 = 1'b0;
end

#5 $stop;

end

initial 
	$monitor("TIME=%0d, OUT=%b" , $time, out);


endmodule
