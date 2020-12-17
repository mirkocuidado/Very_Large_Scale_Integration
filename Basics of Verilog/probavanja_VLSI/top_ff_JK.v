module top_jk_ff;
  
reg j,k,clk,rst;

wire q;

jk_ff instanca(clk,rst,j,k,q);

initial begin
  clk = 1'b0;
  j = 1'b0;
  k = 1'b0;
  rst = 1'b1;
  
  #100 rst = 1'b0;
  #0 rst = 1'b1;
  #50 $finish;
  
end

always
#3 clk = ~clk;
  
always begin
#2 j=~j;

#10 k=~k;

#10 j=~j;

end
  
endmodule
