module regN #( parameter WIDTH = 8, parameter HIGH = WIDTH - 1)
					( input clk,  input rst, input ld, input inc, input [HIGH:0] in, output [HIGH:0] out);
					
		reg[HIGH:0] out_next;
		reg[HIGH:0] out_reg;
		
		assign out = out_reg;
		
		always@ (posedge clk, negedge rst) begin
			if(!rst) begin
				out_reg <= {WIDTH{1'b0}};
			end
			else begin
				out_reg <= out_next;
			end
		end

		always @(*) begin
			out_next = out_reg;
			if(ld) out_next = in;
			else if(inc) out_next = out_reg + 1'b1;
		end
		
endmodule