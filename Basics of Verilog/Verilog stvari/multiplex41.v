module multiplex41(out,in0,in1,in2,in3,s);

input in0, in1, in2, in3;
input [1:0] s;
output reg out;

always@(in0, in1, in2, in3, s) begin

	case (s)
	2'b00: out = in0;
	2'b01: out = in1;
	2'b10: out = in2;
	2'b11: out = in3;
	endcase

end

endmodule
