//RTL code for router sync
module router_sync(detect_add,data_in,w_en_reg,clk,rstn,vld_out0,vld_out1,vld_out2,re0,re1,re2,w_en,
		    fifo_full,empty0,empty1,empty2,soft_rst0,soft_rst1,soft_rst2,full0,full1,full2);

	input [1:0]data_in;
	input detect_add,w_en_reg,clk,rstn,re0,re1,re2,empty0,empty1,empty2,full0,full1,full2;
	output reg [2:0]w_en;
	output reg fifo_full,soft_rst0,soft_rst1,soft_rst2;
	output vld_out0,vld_out1,vld_out2;
	reg [1:0]addr;
	reg [4:0]count0,count1,count2;

	always@(posedge clk)
		begin
				if(~rstn)
						addr <= 0;
				else if(detect_add == 1)
						addr <= data_in;
				else
					addr <= addr;
		end
	
	always@(*)
		begin
				case(data_in)
						2'b00 : fifo_full = full0;
						2'b01 : fifo_full = full1;
						2'b10 : fifo_full = full2;
						default : fifo_full = 0;
				endcase
		end

	assign vld_out0 = ~empty0;
	assign vld_out1 = ~empty1;
	assign vld_out2 = ~empty2;

	always@(*)
		begin
				if(w_en_reg == 1)
					begin
							case(addr)
									2'b00 : w_en = 3'b001;
									2'b01 : w_en = 3'b010;
									2'b10 : w_en = 3'b100;
									default : w_en = 3'b000;
							endcase
					end
				else
						w_en = 3'b000;
		end
	
	always@(posedge clk)
		begin
				if(~rstn)
					begin
							count0 <= 5'd0;
							soft_rst0 <= 0;
					end
				else if(~vld_out0)
					begin
							count0 <= 5'd1;
							soft_rst0 <= 0;
					end
				else if(re0)
					begin
							count0 <= 5'd1;
							soft_rst0 <= 0;
					end
				else if(count0 == 5'd30)
					begin
							count0 <= 5'd1;
							soft_rst0 <= 1;
					end
				else
				begin
						count0 <= count0 + 5'd1;
						soft_rst0 <= 0;
						end
		end

		always@(posedge clk)
		begin
				if(~rstn)
					begin
							count1 <= 5'd0;
							soft_rst1 <= 0;
					end
				else if(~vld_out1)
					begin
							count1 <= 5'd1;
							soft_rst1 <= 0;
					end
				else if(re1)
					begin
							count1 <= 5'd1;
							soft_rst1 <= 0;
					end
				else if(count1 == 5'd30)
					begin
							count1 <= 5'd1;
							soft_rst1 <= 1;
					end
				else
				begin
						count1 <= count1 + 5'd1;
						soft_rst1 <= 0;
						end
		end

		always@(posedge clk)
		begin
				if(~rstn)
					begin
							count2 <= 5'd0;
							soft_rst2 <= 0;
					end
				else if(~vld_out2)
					begin
							count2 <= 5'd1;
							soft_rst2 <= 0;
					end
				else if(re2)
					begin
							count2 <= 5'd1;
							soft_rst2 <= 0;
					end
				else if(count2 == 5'd30)
					begin
							count2 <= 5'd1;
							soft_rst2 <= 1;
					end
				else
				begin
						count2 <= count2 + 5'd1;
						soft_rst2 <= 0;
					end
		end

endmodule
