module top_d_ff;
  
reg clk, rst, d;
wire q;

d_ff delay(.clk(clk), .rst(rst), .d(d), .q(q));

initial 
begin
  clk = 1'b0;
  rst = 1'b1;
  d = 1'b0;
  
  #43 rst = 1'b0;
  #0 rst = 1'b1;
  #7 $finish;
end

always
#5 clk = ~clk;

always
#3 d = ~d;

endmodule
