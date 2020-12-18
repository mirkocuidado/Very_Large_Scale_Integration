module stavka_f #( parameter SECOND = 50_000_000)
(
input clk,
input rst_n,
input [3:0] data_in,
input ld,
input inc,
output [6:0] data_out
);

wire [3:0] help_out;

assign data_out = hex7(help_out);

stavka_e instanca(clk,rst_n, data_in, ld, inc, help_out);

function [6:0] hex7 (
	input [3:0] in
);
begin
	case (in)
	4'b0000: hex7 = ~7'h3F;
	4'b0001: hex7 = ~7'h06;
	4'b0010: hex7 = ~7'h5B;
	4'b0011: hex7 = ~7'h4F;
	4'b0100: hex7 = ~7'h66;
	4'b0101: hex7 = ~7'h6D;
	4'b0110: hex7 = ~7'h7D;
	4'b0111: hex7 = ~7'h07;
	4'b1000: hex7 = ~7'h7F;
	4'b1001: hex7 = ~7'h6F;
	4'b1010: hex7 = ~7'b0000000;
	4'b1011: hex7 = ~7'b0111000;
	4'b1100: hex7 = ~7'b1110110;
	4'b1101: hex7 = ~7'h5E;
	4'b1110: hex7 = ~7'h79;
	4'b1111: hex7 = ~7'h71;
	endcase
end
endfunction


endmodule
