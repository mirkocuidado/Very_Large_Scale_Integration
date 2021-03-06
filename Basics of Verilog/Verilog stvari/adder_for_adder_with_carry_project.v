module adder_for_two_bits_with_carry(outBit, outCarry, inCarry, inBit0, inBit1);

input inBit0, inBit1, inCarry;
output reg outBit, outCarry;

always @(inBit0, inBit1, inCarry) begin

	if(inBit0==1'b1 && inBit1==1'b1 || inBit0==1'b1 && inCarry ==  1'b1 || inCarry == 1'b1 && inBit1==1'b1) outCarry = 1'b1;
	else outCarry = 1'b0;

	outBit = inBit0 + inBit1 + inCarry;
end

endmodule
