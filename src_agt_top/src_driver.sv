//source driver 

class src_driver extends uvm_driver #(src_xtn);

	`uvm_component_utils(src_driver)

	virtual router_if.SRC_DRV_MP vif;
	router_src_agent_config src_cfg;

	function new(string name ="src_driver", uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!(uvm_config_db #(router_src_agent_config) :: get(this,"","router_src_agent_config",src_cfg)))
			`uvm_fatal("SRC_DRV","set not configured")
		$display("src_config %p",src_cfg);
	endfunction


	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif = src_cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		$display("run phase");
		super.run_phase(phase);
		@(vif.src_drv);
			vif.src_drv.rstn<=1'b0;
		$display("run phase1");	
		repeat(2)
		@(vif.src_drv);
			vif.src_drv.rstn<=1'b1;
		forever
			begin
				seq_item_port.get_next_item(req);
				$display("Before task");
				send_to_dut(req);
				$display("after task");
			//	req.print();
				seq_item_port.item_done();
			end
	endtask

	task send_to_dut(src_xtn xtn);
		while(vif.src_drv.busy!==0)
		@(vif.src_drv);
			vif.src_drv.pkt_vld<=1'b1;
			vif.src_drv.data_in<=req.header;
		@(vif.src_drv);
			foreach(req.payload[i])
			 begin
				while(vif.src_drv.busy!==0)
				@(vif.src_drv);
					vif.src_drv.data_in<=req.payload[i];
				@(vif.src_drv);
			 end
		vif.src_drv.pkt_vld<=1'b0;
		vif.src_drv.data_in<=req.parity;
		repeat(2)
		@(vif.src_drv);
			//req.error = vif.src_drv.error;
		`uvm_info("SRC_DRV",$sformatf("data from Driver \n %s",xtn.sprint()),UVM_MEDIUM)
	endtask
		

endclass
