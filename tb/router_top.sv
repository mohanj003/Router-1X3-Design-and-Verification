//Router top 

module top;

	import uvm_pkg::*;
	import router_pkg::*;

	bit clk = 0;
	always
		#5 clk = ~clk;
	
	router_if src_if0(clk);
	router_if dst_if0(clk);
	router_if dst_if1(clk);
	router_if dst_if2(clk);

	router_top dut(.clk(clk),.rstn(src_if0.rstn),.re0(dst_if0.read_enb),.re1(dst_if1.read_enb),.re2(dst_if2.read_enb),.data_in(src_if0.data_in),
		.pkt_vld(src_if0.pkt_vld),.data_out0(dst_if0.data_out),.data_out1(dst_if1.data_out),.data_out2(dst_if2.data_out),.vld_out0(dst_if0.valid_out),
		.vld_out1(dst_if1.valid_out),.vld_out2(dst_if2.valid_out),.error(src_if0.error),.busy(src_if0.busy));


	initial
		begin
			`ifdef VCS
         		$fsdbDumpvars(0, top);
        		`endif

			uvm_config_db #(virtual router_if) :: set(null,"*","src_if0",src_if0);
			uvm_config_db #(virtual router_if) :: set(null,"*","dst_if0",dst_if0);
			uvm_config_db #(virtual router_if) :: set(null,"*","dst_if1",dst_if1);
			uvm_config_db #(virtual router_if) :: set(null,"*","dst_if2",dst_if2);

			run_test();
		end

endmodule	
