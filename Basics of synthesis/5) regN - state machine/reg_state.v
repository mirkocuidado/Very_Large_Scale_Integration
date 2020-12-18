module regN #(
	parameter WIDTH=8, HIGH = WIDTH -1
)
(input clk, input rst, input [HIGH:0] in, input ld_inc, input select, output [HIGH:0] out);

reg [HIGH:0] out_next, out_reg;

localparam load = 1'b0;
localparam increment = 1'b1;

reg state_reg, state_next;

assign out = out_reg;

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		out_reg <= {WIDTH{1'b0}};
		state_reg <= load;
	end 
	else begin
		out_reg <= out_next;
		state_reg <= state_next;
	end
end

always @(*) begin
	out_next = out_reg;
	state_next = state_reg;
	
	case(state_reg)
	load: 
		begin
			if(select == 1'b1) state_next = increment;
			if(ld_inc) out_next = in;
		end
	increment: 
		begin
			if(select == 1'b0) state_next = load;
			if(ld_inc) out_next = out_reg + 1'b1;
		end
	endcase
end


endmodule