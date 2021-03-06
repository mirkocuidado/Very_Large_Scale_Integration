module imaginative_guy_are_you(clk, rst, in0, in1, in2, in3, ctrl1, ctrl2, out);

input clk, rst;
input [3:0] in0;
input [3:0] in1;
input [3:0] in2;
input [3:0] in3;
input [1:0] ctrl2;
input [1:0] ctrl1;
output reg [3:0] out;

reg [3:0] helper;

reg lucky;
reg more;

always @(posedge clk, negedge rst) 
	if(!rst)
		out<=4'b0000;
	else
		out<=helper;

always @(in0, in1, in2, in3, ctrl1, ctrl2, out) begin
if(ctrl1 == 2'b00) begin
	if(ctrl2 == 2'b00) begin
		lucky = in0[0] + in1[0] + in2[0] + in3[0];
		helper = {in0[3:1], lucky};
	end
	else if(ctrl2 == 2'b01) begin
		lucky = in0[1] + in1[1] + in2[1] + in3[1];
		helper = {in1[3:2], lucky, in1[0]};
	end
	else if(ctrl2 == 2'b10) begin
		lucky = in0[2] + in1[2] + in2[2] + in3[2];
		helper = {in2[3], lucky, in2[1:0]};
	end
	else if(ctrl2 == 2'b11) begin
		lucky = in0[3] + in1[3] + in2[3] + in3[3];
		helper = {lucky, in3[2:0]};
	end
end
else if(ctrl1 == 2'b01) begin
	if(ctrl2 == 2'b00) begin
		lucky = in0[0] + in1[0] + in2[0] + in3[0];
		helper = {in0[3:1], lucky};
	end
	else if(ctrl2 == 2'b01) begin
		more = in0[0] + in1[0] + in2[0] + in3[0];
		lucky = in0[1] + in1[1] + in2[1] + in3[1];
		helper = {in1[3:2], lucky, more};
	end
	else if(ctrl2 == 2'b10) begin
		more = in0[1] + in1[1] + in2[1] + in3[1];
		lucky = in0[2] + in1[2] + in2[2] + in3[2];
		helper = {in2[3], lucky, more, in2[0]};
	end
	else if(ctrl2 == 2'b11) begin
		more = in0[2] + in1[2] + in2[2] + in3[2];
		lucky = in0[3] + in1[3] + in2[3] + in3[3];
		helper = {lucky, more, in3[2:0]};
	end
end
else if(ctrl1 == 2'b10) begin
	helper = out + {{3{1'b0}},1'b1};
end
else if(ctrl1 == 2'b11) begin
	helper = out << 2;
end
end
endmodule
