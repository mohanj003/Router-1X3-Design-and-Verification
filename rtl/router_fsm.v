//RTL for Router FSM
module router_fsm(clk,rstn,pkt_vld,busy,parity_done,data_in,soft_rst0,soft_rst1,soft_rst2,fifo_full,low_pkt_vld,
		   fifo_empty0,fifo_empty1,fifo_empty2,detect_add,ld_state,laf_state,full_state,w_en_reg,rst_int_reg,lfd_state);

		   input [1:0]data_in;
		   input clk,rstn,pkt_vld,parity_done,soft_rst0,soft_rst1,soft_rst2,fifo_full,low_pkt_vld,fifo_empty0,fifo_empty1,fifo_empty2;
		   output busy,detect_add,ld_state,laf_state,full_state,w_en_reg,rst_int_reg,lfd_state;

		   localparam DECODE_ADDRESS  		= 	3'd0,
			          LOAD_FIRST_DATA		=	3'd1,
			          WAIT_TILL_EMPTY		=  3'd2,
						 LOAD_DATA 				=	3'd3,
						 FIFO_FULL_STATE  	=	3'd4,
						 LOAD_PARITY 			=	3'd5,
						 LOAD_AFTER_FULL		=	3'd6,
						 CHECK_PARITY_ERROR	=	3'd7;

			reg [2:0]state,next_state;
		//	reg [1:0]addr;

			always@(posedge clk)
				begin
						  if(~rstn)
									 state <= DECODE_ADDRESS;
						  else if(soft_rst0 || soft_rst1 || soft_rst2)
									 state <= DECODE_ADDRESS;
						  else
									 state <= next_state;
				end
		 /* always@(posedge clk)
		  	begin
					  if(~rstn)
								 addr <= 0;
					  else if(pkt_vld)
								 addr <= data_in;
			end*/

		 always@(*)
		 	begin
					  case(state)
								 DECODE_ADDRESS : if((pkt_vld && data_in[1:0] == 2'b00 && fifo_empty0) || (pkt_vld && data_in[1:0] == 2'b01 && fifo_empty1) || (pkt_vld && data_in[1:0] == 2'b10 && fifo_empty2))
														next_state = LOAD_FIRST_DATA;
											else if((pkt_vld && data_in[1:0] == 2'b00 && !fifo_empty0) || (pkt_vld && data_in[1:0] == 2'b01 && !fifo_empty1) || (pkt_vld && data_in[1:0] == 2'b10 && !fifo_empty2))
													  next_state = WAIT_TILL_EMPTY;
											else
													  next_state = DECODE_ADDRESS;

								WAIT_TILL_EMPTY : if((fifo_empty0 && data_in[1:0] ==2'b00) || (fifo_empty1 && data_in[1:0] ==2'b01) || (fifo_empty2 && data_in[1:0] ==2'b10))
							                       next_state = LOAD_FIRST_DATA;
											else
													  next_state = WAIT_TILL_EMPTY;

								LOAD_FIRST_DATA : next_state = LOAD_DATA;

								LOAD_DATA : if(!fifo_full && !pkt_vld)
													next_state = LOAD_PARITY;
										 else if(fifo_full)
													next_state = FIFO_FULL_STATE;
										 else
													next_state = LOAD_DATA;

								FIFO_FULL_STATE : if(!fifo_full)
														next_state = LOAD_AFTER_FULL;
											 else
														next_state = FIFO_FULL_STATE;

								LOAD_PARITY : next_state = CHECK_PARITY_ERROR;

								CHECK_PARITY_ERROR : if(!fifo_full)
																next_state = DECODE_ADDRESS;
													 else
																next_state = FIFO_FULL_STATE;

								LOAD_AFTER_FULL : if(!parity_done && !low_pkt_vld)
																next_state = LOAD_DATA;
													 else if(!parity_done && low_pkt_vld)
																next_state = LOAD_PARITY;
													 else if(parity_done)
																next_state = DECODE_ADDRESS;
													 else
																next_state = LOAD_AFTER_FULL;
								default : next_state = DECODE_ADDRESS;
						endcase
				end


			assign detect_add 	= (state == DECODE_ADDRESS);
		   assign ld_state 		= (state == LOAD_DATA);
		   assign laf_state 		= (state == LOAD_AFTER_FULL);
			assign full_state 	= (state == FIFO_FULL_STATE);
			assign w_en_reg		= (state == LOAD_DATA || state == LOAD_PARITY || state == LOAD_AFTER_FULL);
			assign rst_int_reg	= (state == CHECK_PARITY_ERROR);
			assign lfd_state		= (state == LOAD_FIRST_DATA);
			assign busy				= (state == LOAD_AFTER_FULL || state == FIFO_FULL_STATE || state == LOAD_PARITY || state == CHECK_PARITY_ERROR || state == LOAD_FIRST_DATA || state == WAIT_TILL_EMPTY);

			endmodule	
