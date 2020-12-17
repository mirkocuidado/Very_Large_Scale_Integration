module dut(clk,rst,in,ctrl,out);
  
  input clk, rst;
  input [3:0] in;
  input [2:0] ctrl;
  output reg [3:0] out;
  
  reg [3:0] helper;
  
  always @(posedge clk, negedge rst)
    if(!rst) 
      out<=4'b0000;
    else 
      out<=helper;
      
  always @(*) begin
    
    helper = out;
    
    if(ctrl[0]==1'b1) begin
      
      if(ctrl[1] == 1'b0) helper = in;
      else helper = in << 1;
        
      if(ctrl[2] == 1'b0) helper = helper;
      else helper = helper + {{3{1'b0}},1'b1};
        
    end
  
  end  
  
endmodule
