module red_dual #(parameter SECONDS = 50_000_000)
				(input clk, input rst, input in, input in2, output reg holder);

reg ff1_reg, ff1_next;
reg ff2_reg, ff2_next;
reg ff3_reg, ff3_next;
reg ff4_reg, ff4_next;

integer timer_reg, timer_next;

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		ff1_reg <= 1'b0;
		ff2_reg <= 1'b0;
		ff3_reg <= 1'b0;
		ff4_reg <= 1'b0;
		timer_reg <= 0;
	end
	else if(clk) begin
		ff1_reg <= ff1_next;
		ff2_reg <= ff2_next;
		ff3_reg <= ff3_next;
		ff4_reg <= ff4_next;
		timer_reg <= timer_next;
	end
end

always @(*) begin
	ff1_next = in;
	ff2_next = ff1_reg;
	ff3_next = in2;
	ff4_next = ff3_reg;
	timer_next = timer_reg;
	holder = 1'b0;
	
	if(ff1_reg == 1'b1 && ff2_reg == 1'b1 && ff3_reg == 1'b1 && ff4_reg == 1'b1) begin
		timer_next = timer_reg + 1'b1;
	end
	else if( (ff1_reg == 1'b0 && ff2_reg == 1'b1) || (ff3_reg == 1'b0 && ff4_reg == 1'b1)) begin
		if(timer_reg >= 3*SECONDS) 
			holder = 1'b1;
			
		timer_next = 0;
	end
	
end

endmodule