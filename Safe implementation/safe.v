module safe #(parameter SECONDS = 50_000_000)(input clk, input rst, input action, input[3:0] data, output[1:0] state, output[6:0] out, output[6:0] out1, output[6:0] out2, output[6:0] out3);

/********** shvatio da imam 3 stanja, ispisujem trenutno stanje na led[1:0] i ispis na 7seg moram da vratim zbog onog L za locked **********/
localparam setup = 2'b01;
localparam locked = 2'b10;
localparam show = 2'b11;

reg[1:0] state_reg, state_next;
reg[6:0] display_reg, display_next;

assign state = state_reg;
assign out = display_reg;

/********** nesto moje **********/
reg[6:0] display_reg3, display_next3;
reg[6:0] display_reg2, display_next2;
reg[6:0] display_reg1, display_next1;

assign out3 = display_reg3;
assign out2 = display_reg2;
assign out1 = display_reg1;

/********** shvatio da postoji kraci i duzi klik na dugme, pa imam lock i save zice koje govore koji klik je bio, dok sam u setup **********/
wire lock, save;

red red_instanca(clk, rst, action, save, lock);

/********** shvatio da trebam u neki niz da pamtim PIN i da imam neki niz za proveru istog tog pina posle **********/
reg [3:0] nums_next [2:0];
reg [3:0] nums_reg [2:0];
reg [3:0] check_next [2:0];
reg [3:0] check_reg [2:0];

integer i;

/********** shvatio da mi treba current za ispis i tajmersko racnanje da smenjujem na 2s **********/

integer current_reg, current_next, timer_reg, timer_next;

/********** CODE **********/

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		state_reg <= setup;
		display_reg <= 7'b0000000;
		for(i = 0; i < 3; i = i + 1) begin
			nums_reg[i] <= 4'b0;
			check_reg[i] <= 4'b0;
			display_reg3 <= 7'b0;
			display_reg2 <= 7'b0;
			display_reg1 <= 7'b0;
		end
		current_reg <= 0;
		timer_reg <= 0;
	end
	
	else begin
		state_reg <= state_next;
		display_reg <= display_next;
		timer_reg <= timer_next;
		current_reg <= current_next;
		for(i = 0; i < 3; i = i + 1) begin
			nums_reg[i] <= nums_next[i];
			check_reg[i] <= check_next[i];
			display_reg3 <= display_next3;
			display_reg2 <= display_next2;
			display_reg1 <= display_next1;
		end
	end
end

always @(*) begin
	state_next = state_reg;
	display_next = display_reg;
	for(i = 0; i < 3; i = i + 1) begin
			nums_next[i] = nums_reg[i];
			check_next[i] = check_reg[i];
	end
	display_next3 = display_reg3;
	display_next2 = display_reg2;
	display_next1 = display_reg1;
	timer_next = timer_reg;
	current_next = current_reg;
	
	case(state_reg)
	setup: begin
		if(lock == 1'b1) state_next = locked;
		else if(save == 1'b1) begin
			for(i=2; i>0; i=i-1) begin
				nums_next[i] = nums_reg[i-1];
			end
			nums_next[0] = data;
			display_next = hex7(data);
			display_next3 = hex7(nums_next[2]);
			display_next2 = hex7(nums_next[1]);
			display_next1 = hex7(nums_next[0]);	
		end
	end
	
	locked: begin
			if (check_reg[0] == nums_reg[0] && check_reg[1] == nums_reg[1] && check_reg[2] == nums_reg[2]) begin
				current_next = 0;
				timer_next = 0;
				state_next = show;
			end
			else if(save == 1'b1) begin
				for(i=2; i>0; i=i-1) begin
					check_next[i] = check_reg[i-1];
				end
				check_next[0] = data;
			end
			display_next3 = 7'hC7;
			display_next2 = ~7'h3F;
			display_next1 = 7'hC6;
			display_next = 7'h89;
	end
	
	show: begin
		if(timer_reg == 2*SECONDS) begin
			timer_next = 0;
			current_next = (current_reg + 1) % 3;
		end
		else begin
			timer_next = timer_reg + 1;
			if(save == 1'b1) begin
				state_next = setup;
			end
			else if(lock == 1'b1) begin
				for(i = 0; i < 3; i = i + 1) begin
					check_next[i] = 4'b0000;
				end
				state_next = locked;
			end
		end
		
		display_next = hex7(nums_reg[2-current_reg]);
		display_next3 = ~7'h39;
		display_next2 = ~7'h77;
		display_next1 = ~7'h3F;
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
	4'b1010: hex7 = ~7'h77;
	4'b1011: hex7 = ~7'h7C;
	4'b1100: hex7 = ~7'h39;
	4'b1101: hex7 = ~7'h5E;
	4'b1110: hex7 = ~7'h79;
	4'b1111: hex7 = ~7'h71;
	endcase
end
endfunction

endmodule