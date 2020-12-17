module mix_devices(input clk, input rst, input button1, input button2, input [1:0] selection, output [4:0] out1, output [4:0] out2);

	device device_instanca1(clk, rst, selection[1], button1, button2, out1);
	device device_instanca2(clk, rst, selection[0], button1, button2, out2);
	
endmodule
