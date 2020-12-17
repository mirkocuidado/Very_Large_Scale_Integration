module adder_with_carry_for_four_bits(in1, in2, out, carry0);

input [3:0] in1, in2;
input carry0;
output [3:0] out;

wire carry1, carry2, carry3, carry4;

adder_for_two_bits_with_carry a0(out[0], carry1, carry0, in1[0], in2[0]);
adder_for_two_bits_with_carry a1(out[1], carry2, carry1, in1[1], in2[1]);
adder_for_two_bits_with_carry a2(out[2], carry3, carry2, in1[2], in2[2]);
adder_for_two_bits_with_carry a3(out[3], carry4, carry3, in1[3], in2[3]);


always @(in1, in2, out, carry0) begin
end

endmodule
