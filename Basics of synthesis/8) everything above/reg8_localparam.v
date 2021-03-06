module reg8_localparam(input clk, input rst, input[7:0] in, input ld_inc, input choose, output[7:0] out);

localparam LOAD = 1'b0;
localparam INCREMENT = 1'b1;

reg [7:0] out_next;
reg [7:0] out_reg;

reg state_next, state_reg;

assign out = out_reg;

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		out_reg <= 8'h00;
		state_reg <= 1'b0;
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
		LOAD: begin
			if(choose == 1'b1) state_next = INCREMENT;
			if(ld_inc) out_next = in;
		end
		
		INCREMENT: begin
			if(choose == 1'b0) state_next = LOAD;
			if(ld_inc) out_next = out_reg + 1'b1;
		end
	endcase;
end

endmodule