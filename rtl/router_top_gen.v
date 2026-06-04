//Rtl for router_top block using genvar
module router_top(clk,rstn,re0,re1,re2,data_in,pkt_vld,
		            data_out0,data_out1,data_out2,vld_out0,vld_out1,vld_out2,error,busy);

			 input  clk,rstn,re0,re1,re2,pkt_vld;
			 input  [7:0]data_in;
			 output [7:0]data_out0,data_out1,data_out2;
			 output vld_out0,vld_out1,vld_out2,error,busy;

			 wire parity_done,fifo_full,low_pkt_vld,detect_add,ld_state,lfd_state,laf_state,full_state,w_en_reg,rst_int_reg;

			wire [2:0]w_en;
 			wire [7:0]dout;
			wire [7:0]data_out_w[0:2];
			wire [2:0]soft_rst,empty,full;
			wire [2:0]re_w = {re2,re1,re0};

			assign data_out0 = data_out_w[0];
			assign data_out1 = data_out_w[1];
			assign data_out2 = data_out_w[2];

			genvar i;
			generate for(i=0;i<3;i=i+1)
					  begin : FIFO
						     router_fifo FIFO (clk,rstn,w_en[i],re_w[i],dout,data_out_w[i],full[i],empty[i],lfd_state,soft_rst[i]);
					  end
			endgenerate


			router_sync SYNC (detect_add,data_in[1:0],w_en_reg,clk,rstn,vld_out0,vld_out1,vld_out2,re_w[0],re_w[1],re_w[2],w_en,
		                      fifo_full,empty[0],empty[1],empty[2],soft_rst[0],soft_rst[1],soft_rst[2],full[0],full[1],full[2]);
			router_fsm FSM (clk,rstn,pkt_vld,busy,parity_done,data_in[1:0],soft_rst[0],soft_rst[1],soft_rst[2],fifo_full,low_pkt_vld,
		                    empty[0],empty[1],empty[2],detect_add,ld_state,laf_state,full_state,w_en_reg,rst_int_reg,lfd_state);
			router_reg REG (clk,rstn,pkt_vld,data_in,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,
		  				         full_state,lfd_state,parity_done,low_pkt_vld,error,dout);

endmodule

