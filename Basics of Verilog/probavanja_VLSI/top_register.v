module top_register;
  
reg clk, rst, ld, inc, dec;
reg [7:0] in;
wire [7:0] out;

register_8bit register(.clk(clk), .rst(rst), .ld(ld), .inc(inc), .dec(dec), .in(in), .out(out));

initial begin
rst = 1'b0; 
clk = 1'b0; 
in = 8'h00;
ld = 1'b1;
inc = 1'b0;

#2 rst = 1'b1;
ld = 1'b0;
#100 $finish;
end



always begin
#2 clk = ~clk;
end

always begin
#20 inc = ~inc;
end
endmodule
