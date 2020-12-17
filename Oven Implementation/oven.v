module oven #(
	parameter MAX = 9,
	parameter MIN = 0,
	parameter SECOND = 50_000_000
	)(
	input clk, 
	input rst, 
	input start,       			  /********** BUTTON 0 -> start **********/
	input hotplate1,   			  /********** SWITCH 3 -> HEX3 on **********/
	input hotplate2,       		  /********** SWITCH 2 -> HEX2 on **********/
	input hotter,      			  /********** BUTTON 2 -> raise heat **********/
	input colder,      			  /********** BUTTON 1 -> lower heat **********/
	output [6:0] out_hotplate1,  /********** HEX 3 output **********/
	output [6:0] out_hotplate2,  /********** HEX 2 output **********/
	output out_dot1,				  /********** HEX 3 decimal point output **********/
	output out_dot2,				  /********** HEX 2 decimal point output **********/
	
	/********** Phase 2 **********/
	input buttons_held
);

/********** Phase 1 **********/

localparam turn_on = 3'b000;
localparam use_oven = 3'b001;

reg [2:0] state_reg, state_next;

reg [3:0] out_reg1, out_next1;
reg [3:0] out_reg2, out_next2;
reg out_dot_reg1, out_dot_next1, out_dot_reg2, out_dot_next2;

assign out_hotplate1 = hex7(out_reg1);
assign out_hotplate2 = hex7(out_reg2);
assign out_dot1 = out_dot_reg1;
assign out_dot2 = out_dot_reg2;

/********** Phase 2 **********/

localparam kids = 3'b010;
localparam safety_on = 3'b011;
localparam long_pressed_check = 3'b100;

integer isStarted_reg, isStarted_next;
integer timer_reg, timer_next;

/********** Phase 3 **********/
integer turnedOn1_reg, turnedOn1_next, turnedOn2_reg, turnedOn2_next;
integer timer1_reg, timer1_next, timer2_reg, timer2_next;

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		state_reg <= turn_on;
		out_reg1 <= 4'b1010;
		out_reg2 <= 4'b1010;
		out_dot_reg1 <= 1'b1;
		out_dot_reg2 <= 1'b1;
		turnedOn1_reg <= 0;
		turnedOn2_reg <= 0;
		isStarted_reg <= 0;
		timer_reg <= 0;
		timer1_reg <= 0;
		timer2_reg <= 0;
	end
	else begin
		state_reg <= state_next;
		out_reg1 <= out_next1;
		out_reg2 <= out_next2;
		out_dot_reg1 <= out_dot_next1;
		out_dot_reg2 <= out_dot_next2;
		turnedOn1_reg <= turnedOn1_next;
		turnedOn2_reg <= turnedOn2_next;
		isStarted_reg <= isStarted_next;
		timer_reg <= timer_next;
		timer1_reg <= timer1_next;
		timer2_reg <= timer2_next;
	end
end


always @(*) begin	
	state_next = state_reg;
	out_next1 = out_reg1;
	out_next2 = out_reg2;
	out_dot_next1 = out_dot_reg1;
	out_dot_next2 = out_dot_reg2;
	turnedOn1_next = turnedOn1_reg;
	turnedOn2_next = turnedOn2_reg;
	isStarted_next = isStarted_reg;
	timer1_next = timer1_reg;
	timer2_next = timer2_reg;
	timer_next = timer_reg;
	
	case(state_reg)
	turn_on: begin
	
		if(turnedOn1_reg == 1) begin
			timer1_next = timer1_reg + 1;
			if(timer1_next == 10*SECOND) begin
				out_next1 = 4'b1010;
			end	
		end
		
		if(turnedOn2_reg == 1) begin
			timer2_next = timer2_reg + 1;
			if(timer2_next == 10*SECOND) begin
				out_next2 = 4'b1010;
			end	
		end

		if(start == 1'b1) begin
			out_next1 = 4'b0000;
			out_dot_next1 = 1'b1;
			out_next2 = 4'b0000;
			out_dot_next2 = 1'b1;
			
			isStarted_next = 1;
			state_next = use_oven;
		end
	end
	
	
	
	use_oven: begin
	
		if(buttons_held == 1'b1) begin
			if(isStarted_reg == 1 && out_reg1 == 4'b0000 && out_reg2 == 4'b0000 && out_dot_reg1==1'b1 && out_dot_reg2 == 1'b1) begin
					state_next = long_pressed_check;
			end
		end
	
		if(hotplate1 == 1'b1 && out_reg1 == 4'b0000) begin
			out_dot_next1 = 1'b0;
			turnedOn1_next = 1'b1;
			timer1_next = 0;
			out_next1 = 4'b0000;
		end
		
		if(hotplate2 == 1'b1 && out_reg2 == 4'b0000) begin
			out_dot_next2 = 1'b0;
			turnedOn2_next = 1'b1;
			timer2_next = 0;
			out_next2 = 4'b0000;
		end
		
		if(hotplate1 == 1'b0) begin
			out_dot_next1 = 1'b1;
			if(turnedOn1_reg == 1'b1) begin
				timer1_next = timer1_reg + 1;
				if(timer1_reg > 10 * SECOND) begin
					timer1_next = 0;
					turnedOn1_next = 1'b0;
				end	
			end
			out_next1 = 4'b0000;
		end
		
		if(hotplate2 == 1'b0) begin
			out_dot_next2 = 1'b1;
			if(turnedOn2_reg == 1'b1) begin
				timer2_next = timer2_reg + 1;
				if(timer2_reg > 10 * SECOND) begin
					timer2_next = 0;
					turnedOn2_next = 1'b0;
				end
			end
			out_next2 = 4'b0000;
		end
		
		
		if(start == 1'b1) begin
			
			if(turnedOn1_reg == 1) begin
				timer1_next = 0;
				out_next1 = 4'b1100;
			end
			else begin
				out_next1 = 4'b1010;
			end
			out_dot_next1 = 1'b1;
			
			if(turnedOn2_reg == 1) begin
				timer2_next = 0;
				out_next2 = 4'b1100;
			end
			else begin
				out_next2 = 4'b1010;
			end
			out_dot_next2 = 1'b1;
			
			
			isStarted_next = 0;
			state_next = turn_on;
		end
		
		if(hotter == 1'b1) begin
			if(hotplate1 == 1'b1 && out_reg1 < 4'b1001) begin
				out_next1 = out_reg1 + 1'b1;
			end
			if(hotplate2 == 1'b1 && out_reg2 < 4'b1001) begin
				out_next2 = out_reg2 + 1'b1;
			end
		end
		
		if(colder == 1'b1) begin
			if(hotplate1 == 1'b1 && out_reg1 > 4'b0000) begin
				out_next1 = out_reg1 - 1'b1;
			end
			if(hotplate2 == 1'b1 && out_reg2 > 4'b0000) begin
				out_next2 = out_reg2 - 1'b1;
			end
		end
		
	end
	
	
	long_pressed_check: begin
		out_next1 = 4'b1011;
		out_dot_next1 = 1'b1;
		out_next2 = 4'b1011;
		out_dot_next2 = 1'b1;
		
		if(hotter == 1'b1) begin
			state_next = kids;
			timer_next = 0;
		end
		if(colder == 1'b1) begin
			state_next = turn_on;
			timer_next = 0;
		end
	end
	
	
	kids: begin
		timer_next = timer_reg + 1;
		if(timer_reg == 2 * SECOND) begin
			timer_next = 0;
			out_next1 = 4'b1010;
			out_dot_next1 = 1'b1;
			out_next2 = 4'b1010;
			out_dot_next2 = 1'b1;
			
			isStarted_next = 0;
			state_next = safety_on;
		end
	end
	
	safety_on: begin
		out_next1 = 4'b1010;
		out_dot_next1 = 1'b1;
		out_next2 = 4'b1010;
		out_dot_next2 = 1'b1;
			
		if(start == 1'b1) begin
			timer_next = 0;
			out_next1 = 4'b1011;
			out_dot_next1 = 1'b1;
			out_next2 = 4'b1011;
			out_dot_next2 = 1'b1;
			
			state_next = kids;		
			isStarted_next = 0;
		end	
		
		if(buttons_held == 1'b1) begin
				state_next = long_pressed_check;
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
	4'b1010: hex7 = ~7'b0000000;
	4'b1011: hex7 = ~7'b0111000;
	4'b1100: hex7 = ~7'b1110110;
	4'b1101: hex7 = ~7'h5E;
	4'b1110: hex7 = ~7'h79;
	4'b1111: hex7 = ~7'h71;
	endcase
end
endfunction

endmodule
