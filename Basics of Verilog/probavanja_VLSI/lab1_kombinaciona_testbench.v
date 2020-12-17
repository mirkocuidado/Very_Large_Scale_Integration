module lab1_kombinaciona_testbench;
  
  reg [6:0] in;
  reg ctrl;
  wire [7:0] out;
  
  dut instanca (.in(in) , .ctrl(ctrl) , .out(out) );
  
  integer index = 0;
  
  initial begin
    
    #10 ctrl = 1'b0;
    
    for(index = 0; index < 128; index = index + 1) begin
        #10 in = index;
    end
    
    #10 ctrl = 1'b1;
    
    for(index = 0; index < 128; index = index + 1) begin
        #10 in = index;
    end
    
    $finish;
  end  
  
  always @(out)
    $display (" OUT = %b " , out);
  
  
  
endmodule
