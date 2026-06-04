//Destination driver 

class dst_driver extends uvm_driver #(dst_xtn);

	`uvm_component_utils(dst_driver)

	virtual router_if.DST_DRV_MP vif;
	router_dst_agent_config dst_cfg;

	function new(string name ="dst_driver", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!(uvm_config_db #(router_dst_agent_config) :: get(this,"","router_dst_agent_config",dst_cfg)))
			`uvm_fatal("DST_DRV","set not configured")
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif = dst_cfg.vif;
	endfunction

		
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				seq_item_port.item_done();
			end
	endtask	

	task send_to_dut(dst_xtn req);

		while(vif.dst_drv.valid_out!==1)
		@(vif.dst_drv);
		repeat(req.clk_cycles)
		//@(vif.dst_drv);
		vif.dst_drv.read_enb<=1'b1;
		@(vif.dst_drv);
		while(vif.dst_drv.valid_out!==0)
		@(vif.dst_drv);
		vif.dst_drv.read_enb<=1'b0;
		//@(vif.dst_drv);
//		@(vif.dst_drv);
		`uvm_info("DST_DRIVER",$sformatf("printing from driver \n %s", req.sprint()),UVM_LOW) 
	endtask


endclass
