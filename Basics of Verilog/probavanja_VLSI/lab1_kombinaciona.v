module dut(out, in, ctrl);
  
  input [6:0] in;
  input ctrl;
  output reg [7:0] out;
  
  integer index, num0;
  reg pom;
  
  always @(in, ctrl) begin
    
    num0 = 0;
    
    for(index=0; index<7; index=index+1) begin
      if(in[index] == 1'b0) num0 = num0 + 1;
    end
    
    // retardirani uslovi zadatka  
    if(ctrl==1'b0)
      if(num0 > 3) pom = 1'b1; 
      else pom = 1'b0;
    else 
      if(num0 > 3) pom = 1'b0;
      else pom = 1'b1;
    
    out = { in[6:4] , pom , in[3:0] };
    
  end
  
  
endmodule
