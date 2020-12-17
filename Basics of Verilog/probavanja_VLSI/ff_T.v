module t_ff(clk,rst,t,q);
  
input clk, rst, t;
output reg q = 1'b0;

always @(posedge clk, negedge rst)
  if(!rst) q<=1'b0;
  else if(t) q=~q;
  else q=q;

endmodule
