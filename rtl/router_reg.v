module router_reg(clk,rstn,pkt_vld,data_in,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,
		  				full_state,lfd_state,parity_done,low_pkt_vld,err,dout);

			 input clk,rstn,pkt_vld,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
			 input [7:0]data_in;
			 output reg[7:0]dout;
			 output  reg parity_done,low_pkt_vld,err;

			 reg [7:0]header,fifo_full_state,int_parity,pkt_parity;

			 always@(posedge clk)
			 	begin
						  if(~rstn)
									 dout <= 8'b0;
						  else if(detect_add && pkt_vld && data_in[1:0] != 3)
									 dout <= dout;
						  else if(lfd_state)
									 dout <= header;
						  else if(ld_state && ~fifo_full)
									 dout <= data_in;
						  else if(ld_state && fifo_full)
									 dout <= dout;
						  else if(laf_state)
									 dout <= fifo_full_state;
						  else
							  dout <= dout;
				end
		//header
			always@(posedge clk)
				begin
						  if(~rstn)
									 header <= 8'b0;
						  else if(detect_add && pkt_vld && data_in[1:0] != 3)
									 header <= data_in;
						  else
							  header <= header;
				end

	  //internal parity
	  		always@(posedge clk)
				begin
						  if(~rstn)
									 int_parity <= 8'b0;
						  else if(detect_add)
									 int_parity <= 8'b0;
						  else if(lfd_state)
									 int_parity <= int_parity ^ header;
						  else if(pkt_vld && ld_state && ~full_state)
									 int_parity <= int_parity ^ data_in;
						  else
							  int_parity <= int_parity;
				end

		//pecket parity
			always@(posedge clk)
				begin
						  if(~rstn)
									 pkt_parity <= 8'b0;
						  else if(detect_add)
									 pkt_parity <= 8'b0;
						  else if(ld_state && ~pkt_vld)
									 pkt_parity <= data_in;
					  	  else
							  pkt_parity <= pkt_parity;
				end

		//error
		   always@(posedge clk)
				begin
						  if(~rstn)
									 err <= 0;
						  else if(pkt_parity == int_parity)
									 err <= 0;
						  else if(pkt_parity != int_parity)
									 err <= 1;
						  else
									 err <= err;
				end

	//low packet valid
	      always@(posedge clk)
				begin
						  if(~rstn)
									 low_pkt_vld <= 8'b0;
						  else if(ld_state && ~pkt_vld)
									 low_pkt_vld <= 1;
						  else if(rst_int_reg)
									 low_pkt_vld <= 0;
						  else
							  low_pkt_vld <= low_pkt_vld;
				end
 


	//parity done
	     always@(posedge clk)
		  	begin
					  if(~rstn || detect_add)
								 parity_done <= 0;
					  else if(ld_state && (~fifo_full && ~pkt_vld) || (lfd_state && low_pkt_vld) && parity_done)
								 parity_done <= 1'b1;
					  else
						  parity_done <= parity_done;
		   end

	//fifo_full_state
	     always@(posedge clk)
		  	begin
					  if(~rstn)
								 fifo_full_state <= 0;
					  else if(ld_state && fifo_full)
								 fifo_full_state <= data_in;
					  else
						  fifo_full_state <= fifo_full_state;
			end

	endmodule
