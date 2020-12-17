module register_8bit(clk,rst,ld,inc,dec,in,out);
  
input clk, rst, ld, inc, dec;
input [7:0] in;
output reg [7:0] out;

always @(posedge clk, negedge rst)
  if(!rst) out<=8'h00;
  else if(ld) out<=in;
  else if(inc) out<=out+{{7{1'b0}}, 1'b1};
  else if(dec) out<=out-{{7{1'b0}}, 1'b1};
  
endmodule