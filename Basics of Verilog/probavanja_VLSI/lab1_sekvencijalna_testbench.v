module lab1_sekvencijalna_testbench;
  
  reg clk, rst;
  reg [3:0] in;
  reg [2:0] ctrl;
  wire [3:0] out;
  
  dut instanca(.clk(clk) , .rst(rst) , .in(in) , .ctrl(ctrl) , .out(out));
  
  initial begin
    
    $monitor("TIME=%d , IN=%b , CTRL=%b , OUT=%b" , $time , in, ctrl, out);
    
    rst = 1'b0;
    clk = 1'b1;
    #0 rst = 1'b1;
    
    repeat (100) begin
      #10 in = $urandom_range(15);
      ctrl = $urandom_range(7);
    end  
    
    #10 $finish;
    
  end
  
  always
    #3 clk=~clk;

endmodule
