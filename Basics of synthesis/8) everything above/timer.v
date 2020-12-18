module timer #(parameter SECONDS = 50_000_000)
				  (input clk, input rst, output [9:0] out);
				  
	integer timer_reg, timer_next;
	reg [9:0] out_reg;
	reg [9:0] out_next;
	
	assign out = out_reg;
	
	always @(posedge clk, negedge rst) begin
		if(!rst) begin
			out_reg <= 10'h000;
			timer_reg <= 0;
		end
		else begin
			out_reg <= out_next;
			timer_reg <= timer_next;
		end
	end
	
	always @(*) begin
		timer_next = timer_reg;
		out_next = out_reg;
		
		if(timer_reg == SECONDS) begin
			timer_next = 0;
			out_next = out_reg + 1'b1;
		end
		else timer_next = timer_reg + 1;
	end
				  
endmodule