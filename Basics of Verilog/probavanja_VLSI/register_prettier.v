module register_8bit_prettier(clk,rst,ld,inc,dec,in,out);

input clk, rst, ld, inc, dec;
input [7:0] in;
output reg [7:0] out;

reg [7:0] out_help = 8'h00;

always @(posedge clk, negedge rst)
  if(!rst) out<=8'h00;
  else out<=out_help;

always @(ld, inc, dec, in) begin
  out_help = out;
  if(ld) out_help = in;
  else if(inc) out_help = out + {{7{1'b0}},1'b1};
  else if(dec) out_help = out - {{7{1'b0}},1'b1};
end

endmodule