module top_t_ff;
  
reg clk, rst, t;
wire q;

t_ff delay(.clk(clk), .rst(rst), .t(t), .q(q));

initial 
begin
  clk = 1'b0;
  rst = 1'b1;
  t = 1'b0;
  
  #43 rst = 1'b0;
  #0 rst = 1'b1;
  #7 $finish;
end

always
#5 clk = ~clk;

always
#3 t = ~t;

endmodule
