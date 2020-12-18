module stavka_d(
input clk,
input rst_n,
input [3:0] data_in,
input ld,
input inc,
output [3:0] data_out
);

wire inc_red;
wire ld_red_deb, ld_deb;

stavka_a red_1(clk,rst_n, inc, inc_red);

stavka_b deb_1(clk, rst_n, ld, ld_deb);
stavka_a red_2(clk, rst_n, ld_deb, ld_red_deb);

assign data_out = (state_reg == 2'b00) ? out_reg : helper_reg;

reg [3:0] values_reg [2:0], values_next [2:0];

integer current_reg, current_next;
integer i;

reg [3:0] out_reg, out_next;

/********** UPGRADE c->d **********/
localparam state_c = 2'b00;
localparam state_d = 2'b01;

reg [1:0] state_reg, state_next;

reg [3:0] helper_reg, helper_next;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		for(i = 0; i < 3; i = i + 1)
			values_reg[i] <= 4'b0000;
		current_reg <= 0;
		out_reg <= 4'b0000;
		state_reg <= state_c;
		helper_reg <= 4'b0000;
	end
	else begin
		for(i = 0; i < 3; i = i + 1)
			values_reg[i] <= values_next[i];
		current_reg <= current_next;
		out_reg <= out_next;
		state_reg <= state_next;
		helper_reg <= helper_next;
	end
end

always @(*) begin
	current_next = current_reg;
	out_next = out_reg;
	for(i = 0; i < 3; i = i + 1)
			values_next[i] = values_reg[i];
	state_next = state_reg;
	helper_next = helper_reg;
	
	case(state_reg)
	state_c: begin
		out_next = values_reg[current_reg];
	
		if(values_reg[0]!=0 && values_reg[1] != 0 && values_reg[2] != 0) begin
			state_next = state_d;
		end
		else begin
			if(inc_red == 1'b1) begin
				current_next = (current_reg + 1) % 3;
			end
			else if(ld_red_deb == 1'b1) begin
				values_next[current_reg] = data_in;
				current_next = (current_reg + 1) % 3;
			end
		end
	end
	
	state_d: begin
		if(inc_red == 1'b1) begin
			for(i = 0; i < 3; i = i + 1)
				values_next[i] <= 4'b0000;
			current_next <= 0;
			state_next = state_c;
		end
		else if(ld == 1'b1) begin
			helper_next = (values_reg[0] & values_reg[1] & values_reg[2]);
		end
		else if(ld == 1'b0) begin
			helper_next = (values_reg[0] | values_reg[1] | values_reg[2]);
		end
	end
	endcase
end

endmodule
