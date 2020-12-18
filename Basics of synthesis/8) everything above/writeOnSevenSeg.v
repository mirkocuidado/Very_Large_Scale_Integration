module writeTimeOnSevenSeg(input [9:0] in, output [28:0] out);

	genvar i;
	
	generate
		for(i=0; i<4; i=i+1) begin : block_name
			wire[3:0] digits = (in/10**i)%10;
			
			seven_seg ss(digits, out[7*(i+1)-1: 7*i]);
		end
	endgenerate
endmodule