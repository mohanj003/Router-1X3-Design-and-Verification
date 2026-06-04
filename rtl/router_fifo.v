//Router fifo RTL code
module router_fifo(clk,rstn,we,re,data_in,data_out,full,empty,lfd_state,soft_rst);
	input clk,rstn,we,re,lfd_state,soft_rst;
	input [7:0]data_in;
	output reg [7:0]data_out;
	integer i;
	output full,empty;

	reg [8:0]mem[0:15];
	reg [4:0]r_pt,w_pt;
	reg [6:0]count;
	reg lfd_state_reg;

	always@(posedge clk)
		begin
				  if(~rstn)
							 lfd_state_reg <= 1'b0;
				  else
							 lfd_state_reg <= lfd_state;
		end

	always@(posedge clk)
		begin
			if(~rstn)
			begin
				for(i=0;i<16;i=i+1)
				begin
					mem[i] <= 0;
				
				//data_out <= 8'b0;
				end
				w_pt <= 5'b0;
				
			end
			else if(soft_rst)
			begin
				for(i=0;i<16;i=i+1)
				begin
					mem[i] <= 0;
				//data_out <= 8'bz;
				end
				w_pt <= 5'b0;
				
			end
			else if(we && !full)
				begin
					mem[w_pt[3:0]] <= {lfd_state_reg,data_in};
					w_pt <= w_pt + 1'b1;
				end
			else
					mem[w_pt[3:0]] <= mem[w_pt[3:0]];
		end
	always@(posedge clk)
		begin
			if(~rstn)
			begin
				data_out <= 8'b0;
				r_pt <= 5'b0;
			end
			
			else if(soft_rst)
			begin
				data_out <= 8'bz;
			end
		
			else if(re && !empty)
				begin   
					if(mem[r_pt[3:0]][8] == 1'b1)
					begin
						count <= mem[r_pt[3:0]][7:2] + 1'b1;
						data_out <= mem[r_pt[3:0]][7:0];
						r_pt <= r_pt + 1'b1;
					end
					else if(count != 0)
					begin
						count <= count - 1'b1;
						data_out <= mem[r_pt[3:0]][7:0];
						r_pt <= r_pt + 1'b1;
					end
				end
					else if(count == 0)
						begin
							data_out <= 8'bz;
						end
					else
						data_out <= 8'b0;
		end
			
assign empty = (w_pt == r_pt)? 1'b1:1'b0;
assign full = (w_pt[4] != r_pt[4] && w_pt[3:0] == r_pt[3:0])? 1'b1 : 1'b0;

endmodule
