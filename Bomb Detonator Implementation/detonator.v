module detonator #(
	parameter second = 50_000_000
) (
	input clk,
	input rst_n,
	input [3:0] start,
	output [6:0] out3,
	output [6:0] out2,
	output [6:0] out1,
	output [6:0] out0,
	input button0,
	input button1, 
	input button2,
	output [3:0] out_led
);

localparam counting = 2'b00;
localparam reached = 2'b01;
localparam init = 2'b10;
localparam frozen = 2'b11;

reg [1:0] state_reg, state_next;
reg [6:0] display_reg [3:0], display_next[3:0];
integer num_reg, num_next;
reg show_slash_reg, show_slash_next;

assign out0 = display_reg[0];
assign out1 = display_reg[1];
assign out2 = display_reg[2];
assign out3 = display_reg[3];

integer timer_reg, timer_next;
integer i;

/********** 4. faza **********/
integer buttons_reg[7:0], buttons_next[7:0];
integer check_reg[7:0], check_next[7:0];

integer position_reg, position_next;
integer num_missed_reg, num_missed_next;
assign out_led = out_led_reg;

reg[3:0] out_led_next, out_led_reg;

always @(posedge clk, negedge rst_n)
	if (!rst_n) begin
		for(i = 0; i < 4; i = i + 1)
			display_reg[i] <= 7'h00;
		for(i = 0; i < 8; i = i + 1) begin
			buttons_reg[i] <= 0;
			check_reg[i] <= 0;
		end
		timer_reg <= 0;
		show_slash_reg <= 1'b1;
		state_reg <= init;
		num_reg <= -1;
		position_reg <= 0;
		out_led_reg <= 0;
		num_missed_reg <= 0;
	end
	else begin
		for(i = 0; i < 4; i = i + 1)
			display_reg[i] <= display_next[i];
		for(i = 0; i < 8; i = i + 1) begin
			buttons_reg[i] <= buttons_next[i];
			check_reg[i] <= check_next[i];
		end
		num_reg <= num_next;
		timer_reg <= timer_next;
		show_slash_reg <= show_slash_next;
		state_reg <= state_next;
		position_reg <= position_next;
		out_led_reg <= out_led_next;
		num_missed_reg <= num_missed_next;
	end

always @(*) begin
	for(i = 0; i < 4; i = i + 1)
		display_next[i] = display_reg[i];
	for(i = 0; i < 8; i = i + 1) begin
			buttons_next[i] = buttons_reg[i];
			check_next[i] = check_reg[i];
	end
	num_next = num_reg;
	
	timer_next = timer_reg;
	show_slash_next = show_slash_reg;
	state_next = state_reg;
	position_next = position_reg;
	out_led_next = out_led_reg;
	num_missed_next = num_missed_reg;
	
	case(state_reg)
		init: begin
			if(button0 == 1'b1) begin
				buttons_next[position_reg] = 0;
				position_next = (position_reg + 1) % 8;
			end
			if(button1 == 1'b1) begin
				buttons_next[position_reg] = 1;
				position_next = (position_reg + 1) % 8;
			end
			if(button2 == 1'b1) begin
				buttons_next[position_reg] = 2;
				position_next = (position_reg + 1) % 8;
			end
			if(start != 4'b0000) begin
				if(start[3] == 1'b1) num_next = 9999;
				else if(start[2] == 1'b1) num_next = 999;
				else if(start[1] == 1'b1) num_next = 99;
				else if(start[0] == 1'b1) num_next = 9;
				position_next = 0;
				state_next = counting;
			end
		end
		counting: begin
		
			if(button0 == 1'b1) begin
				check_next[position_reg] = 0;
				if(buttons_reg[position_reg] != 0) begin
					if(num_missed_reg == 0) begin
						out_led_next = 4'b0001;
						num_missed_next = num_missed_reg + 1;
					end
					else if(num_missed_reg == 1) begin
						out_led_next = 4'b0011;
						num_missed_next = num_missed_reg + 1;
					end
					else if(num_missed_reg == 2) begin
						out_led_next = 4'b0111;
						num_missed_next = num_missed_reg + 1;
					end
					else if(num_missed_reg == 3) begin
						state_next = reached;
					end
				end
				position_next = (position_reg + 1) % 8;
			end
			if(button1 == 1'b1) begin
				check_next[position_reg] = 1;
				if(buttons_reg[position_reg] != 1) begin
					if(num_missed_reg == 0) begin
						out_led_next = 4'b0001;
						num_missed_next = num_missed_reg + 1;
					end
					else if(num_missed_reg == 1) begin
						out_led_next = 4'b0011;
						num_missed_next = num_missed_reg + 1;
					end
					else if(num_missed_reg == 2) begin
						out_led_next = 4'b0111;
						num_missed_next = num_missed_reg + 1;
					end
					else if(num_missed_reg == 3) begin
						state_next = reached;
					end
				end 
				position_next = (position_reg + 1) % 8;
			end
			if(button2 == 1'b1) begin
				check_next[position_reg] = 2;
				if(buttons_reg[position_reg] != 2) begin
					if(num_missed_reg == 0) begin
						out_led_next = 4'b0001;
						num_missed_next = num_missed_reg + 1;
					end
					else if(num_missed_reg == 1) begin
						out_led_next = 4'b0011;
						num_missed_next = num_missed_reg + 1;
					end
					else if(num_missed_reg == 2) begin
						out_led_next = 4'b0111;
						num_missed_next = num_missed_reg + 1;
					end
					else if(num_missed_reg == 3) begin
						state_next = reached;
					end
				end
				position_next = (position_reg + 1) % 8;
			end
			
			if(check_reg[0] == buttons_reg[0] && check_reg[1] == buttons_reg[1] && check_reg[2] == buttons_reg[2] && check_reg[3] == buttons_reg[3] &&
				check_reg[4] == buttons_reg[4] && check_reg[5] == buttons_reg[5] && check_reg[6] == buttons_reg[6] && check_reg[7] == buttons_reg[7])
					state_next = frozen;
			
			timer_next = timer_reg + 1;
			if(timer_reg == second) begin
				timer_next = 0;
				if(num_reg > 0) begin
					num_next = num_reg - 1;
				end
				else begin
					state_next = reached;
				end
			end
				/*** ISPIS ***/
				display_next[0] = hex7(num_reg % 10);
				if(start[3]==1'b1 || start[2]==1'b1 || start[1] == 1'b1) display_next[1] = hex7((num_reg / 10) % 10);
				else display_next[1] = 7'hFF; 
				if(start[3]==1'b1 || start[2] == 1'b1) display_next[2] = hex7((num_reg / 100) % 10);
				else display_next[2] = 7'hFF;
				if(start[3] == 1'b1) display_next[3] = hex7((num_reg / 1000) % 10);
				else display_next[3] = 7'hFF;
		end
		frozen: begin
			display_next[0] = hex7(num_reg % 10);
			if(start[3]==1'b1 || start[2]==1'b1 || start[1] == 1'b1) display_next[1] = hex7((num_reg / 10) % 10);
			else display_next[1] = 7'hFF; 
			if(start[3]==1'b1 || start[2] == 1'b1) display_next[2] = hex7((num_reg / 100) % 10);
			else display_next[2] = 7'hFF;
			if(start[3] == 1'b1) display_next[3] = hex7((num_reg / 1000) % 10);
			else display_next[3] = 7'hFF;
		end
		reached: begin
			/*** ISPIS CRTICE NA POLA SEKUNDE ***/
			timer_next = timer_reg + 1;
			if(timer_reg == second / 2) begin
				timer_next = 0;
				if (show_slash_reg == 1'b1) begin
					if(start[0] == 1'b1) display_next[0] = hex7(4'b1010);
					else display_next[0] = 7'hFF;
					if(start[1] == 1'b1) display_next[1] = hex7(4'b1010);
					else display_next[1] = 7'hFF;
					if(start[2] == 1'b1) display_next[2] = hex7(4'b1010);
					else display_next[2] = 7'hFF;
					if(start[3] == 1'b1) display_next[3] = hex7(4'b1010);
					else display_next[3] = 7'hFF;
					show_slash_next = 1'b0;
				end
				else begin
					if(start[0] == 1'b1) display_next[0] = hex7(4'b1011);
					else display_next[0] = 7'hFF;
					if(start[1] == 1'b1) display_next[1] = hex7(4'b1011);
					else display_next[1] = 7'hFF;
					if(start[2] == 1'b1) display_next[2] = hex7(4'b1011);
					else display_next[2] = 7'hFF;
					if(start[3] == 1'b1) display_next[3] = hex7(4'b1011);
					else display_next[3] = 7'hFF;
					show_slash_next = 1'b0;
					show_slash_next = 1'b1;
				end
			end
		end
	endcase
end

function [6:0] hex7 (
	input [3:0] in
);
begin
	case (in)
	4'b0000: hex7 = ~7'h3F;
	4'b0001: hex7 = ~7'h06;
	4'b0010: hex7 = ~7'h5B;
	4'b0011: hex7 = ~7'h4F;
	4'b0100: hex7 = ~7'h66;
	4'b0101: hex7 = ~7'h6D;
	4'b0110: hex7 = ~7'h7D;
	4'b0111: hex7 = ~7'h07;
	4'b1000: hex7 = ~7'h7F;
	4'b1001: hex7 = ~7'h6F;
	4'b1010: hex7 = ~7'b1000000;
	4'b1011: hex7 = ~7'b0000000;
	4'b1100: hex7 = ~7'h39;
	4'b1101: hex7 = ~7'h5E;
	4'b1110: hex7 = ~7'h79;
	4'b1111: hex7 = ~7'h71;
	endcase
end
endfunction

endmodule