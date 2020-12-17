module device#(
parameter SECOND = 50_000_000,
parameter VALUE = 4,
parameter VALUE2 = 0
)
(	
	input clk,
	input rst,
	input do_anything,
	input button1,
	input button2,
	output [4:0] out
);

/********** Phase 1 **********/
localparam wait_for_first_click = 3'b000;
localparam diodes_playing = 3'b001;
localparam wait_for_second_click = 3'b010;

reg [2:0] state_reg, state_next;

reg [4:0] out_reg, out_next;

assign out = out_reg;

integer timer_reg, timer_next;

integer pok1_reg, pok1_next, pok2_reg, pok2_next;
integer clicked_reg, clicked_next;

integer array [8:0];
integer i;

/********** Phase 2 **********/
localparam state_two_init = 3'b011;
localparam state_two_forward = 3'b100;
localparam state_two_backward = 3'b101;
localparam state_two_medium = 3'b110;

integer timer2_reg, timer2_next;
integer pok3_reg, pok3_next;

integer array2 [4:0];

reg [4:0] old_out2_reg, old_out2_next;
reg [2:0] old_state_reg, old_state_next;

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		out_reg <= 5'b00000;
		timer_reg <= 0;
		pok1_reg <= 0;
		pok2_reg <= -1;
		clicked_reg <= 0;
		state_reg <= wait_for_first_click;
		for(i=0; i<9; i=i+1) begin
			if(i<5) array2[i] = i + VALUE2;
			if(i==0) array[i] = VALUE-4;
			else if(i==1) array[i]=VALUE;
			else if(i==2) array[i] = VALUE-3;
			else if(i==3) array[i]=VALUE-1;
			else if(i==4) array[i] = VALUE-2;
			else if(i==5) array[i]= VALUE-3;
			else if(i==6) array[i] = VALUE-1;
			else if(i==7) array[i]= VALUE-4;
			else if(i==8) array[i] = VALUE;
		end
		timer2_reg <= 0;
		pok3_reg <= 0;
		old_out2_reg <= 5'b00000;
		old_state_reg <= state_two_init;
	end
	else begin
		out_reg <= out_next;
		timer_reg <= timer_next;
		pok1_reg <= pok1_next;
		pok2_reg <= pok2_next;
		clicked_reg <= clicked_next;
		state_reg <= state_next;
		timer2_reg <= timer2_next;
		pok3_reg <= pok3_next;
		old_out2_reg <= old_out2_next;
		old_state_reg <= old_state_next;
	end
end

always @(*) begin

	out_next = out_reg;
	timer_next = timer_reg;
	pok1_next = pok1_reg;
	pok2_next = pok2_reg;
	state_next = state_reg;
	clicked_next = clicked_reg;
	for(i=0; i<9; i=i+1) begin
			if(i<5) array2[i] = i + VALUE2;
			if(i==0) array[i] = VALUE-4;
			else if(i==1) array[i]=VALUE;
			else if(i==2) array[i] = VALUE-3;
			else if(i==3) array[i]=VALUE-1;
			else if(i==4) array[i] = VALUE-2;
			else if(i==5) array[i]= VALUE-3;
			else if(i==6) array[i] = VALUE-1;
			else if(i==7) array[i]= VALUE-4;
			else if(i==8) array[i] = VALUE;
	end
	timer2_next = timer2_reg;
	pok3_next = pok3_reg;
	old_out2_next = old_out2_reg;
	old_state_next = old_state_reg;
	
	if(do_anything == 1'b1) begin
		case(state_next)
		wait_for_first_click: begin
			if(button2 == 1'b1) begin
				state_next = diodes_playing;
			end
			if(button1 == 1'b1) begin
				out_next = old_out2_reg;
				old_out2_next = out_reg;
				state_next = old_state_reg;
				old_state_next = wait_for_first_click;
			end
		end
		
		state_two_init: begin
			out_next = 5'b00000;
			if(button2 == 1'b1) begin
				out_next = 5'b00000;
				state_next = state_two_forward;
			end
			if(button1 == 1'b1) begin
				out_next = old_out2_reg;
				old_out2_next = out_reg;
				state_next = old_state_reg;
				old_state_next = state_two_init;
			end
		end
		
		state_two_forward: begin
			timer2_next = timer2_reg + 1;
			
			if(button1 == 1'b1) begin
				out_next = old_out2_reg;
				old_out2_next = out_reg;
				state_next = old_state_reg;
				old_state_next = state_two_forward;
			end
			
			if(timer2_reg == SECOND) begin
				timer2_next = 0;
				if(pok3_reg < 5) begin
					out_next[array2[pok3_reg]] = 1'b1;
					pok3_next = pok3_reg + 1;
				end
				else begin
					pok3_next = 4;
					state_next = state_two_medium;
				end
			end
		end
		
		
		
		
		
		state_two_medium: begin
			if(button2 == 1'b1) begin
				state_next = state_two_backward;
			end
			if(button1 == 1'b1) begin
				out_next = old_out2_reg;
				old_out2_next = out_reg;
				state_next = old_state_reg;
				old_state_next = state_two_medium;
			end
		end
		
		
		
		
		
		
		
		
		
		state_two_backward: begin
			timer2_next = timer2_reg + 1;
			
			if(button1 == 1'b1) begin
				out_next = old_out2_reg;
				old_out2_next = out_reg;
				old_state_next = state_two_backward;
				state_next = old_state_reg;
			end
			
			if(timer2_reg == SECOND) begin
				timer2_next = 0;
				if(pok3_reg >= 0) begin
					out_next[array2[pok3_reg]] = 1'b0;
					pok3_next = pok3_reg - 1;
				end
				else begin
					pok3_next = 0;
					state_next = state_two_init;
				end
			end
		end
		
		
		
		
		
		
		diodes_playing: begin
			timer_next = timer_reg + 1;
			
			if(button1 == 1'b1) begin
				out_next = old_out2_reg;
				old_out2_next = out_reg;
				old_state_next = diodes_playing;
				state_next = old_state_reg;
			end
			
			if(timer_reg == SECOND) begin
				timer_next = 0;
				if(pok1_reg < 9) begin
					out_next[array[pok1_reg]] = 1'b1;
					pok1_next = pok1_reg + 1;
				end
				else begin
					pok1_next = 0;
				end
				
				if(pok2_reg == -1) pok2_next = pok2_reg + 1;
				else if(pok2_reg < 8 && pok2_reg >= 0) begin
					out_next[array[pok2_reg]] = 1'b0;
					pok2_next = pok2_reg + 1;
				end
				else if(pok2_reg == 8) begin
					pok2_next = 0;
					state_next = wait_for_second_click;
				end
			end
			
		end
		
		
		
		
		
		wait_for_second_click: begin
			if(button2 == 1'b1) begin
				out_next[4] = 1'b0;
				timer_next = 0;
				pok2_next = -1;
				pok1_next = 0;
				state_next = diodes_playing;
			end
			
			if(button1 == 1'b1) begin
				out_next = old_out2_reg;
				old_out2_next = out_reg;
				old_state_next = wait_for_second_click;
				state_next = old_state_reg;
			end
		end
		
		
		
		endcase

	end
	else begin
		out_next = 5'b00000;
		timer_next = 0;
		pok1_next = 0;
		pok2_next = -1;
		clicked_next = 0;
		state_next = wait_for_first_click;
		for(i=0; i<9; i=i+1) begin
			if(i<5) array2[i] = i + VALUE2;
			if(i==0) array[i] = VALUE-4;
			else if(i==1) array[i]=VALUE;
			else if(i==2) array[i] = VALUE-3;
			else if(i==3) array[i]=VALUE-1;
			else if(i==4) array[i] = VALUE-2;
			else if(i==5) array[i]= VALUE-3;
			else if(i==6) array[i] = VALUE-1;
			else if(i==7) array[i]= VALUE-4;
			else if(i==8) array[i] = VALUE;
		end
		timer2_next = 0;
		pok3_next = 0;
		old_out2_next = 5'b00000;
		old_state_next = state_two_init;
	end
	
	end

endmodule

