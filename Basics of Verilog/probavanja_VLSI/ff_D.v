module d_ff(clk, rst, d, q);
  
input clk, rst, d;
output reg q;

always @(posedge clk, negedge rst)
  if (!rst)
    q <= 0;
  else
    q <= d;
    
endmodule
