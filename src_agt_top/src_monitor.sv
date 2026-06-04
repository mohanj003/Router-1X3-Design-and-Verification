//source monitor 

class src_monitor extends uvm_monitor;

	`uvm_component_utils(src_monitor)
	
	virtual router_if.SRC_MON_MP vif;
	router_src_agent_config src_cfg;

	function new(string name ="src_monitor", uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!(uvm_config_db #(router_src_agent_config) :: get(this,"","router_src_agent_config",src_cfg)))
			`uvm_fatal("DST_DRV","set not configured")
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif = src_cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever
			begin
				collect_data();
			end
	endtask

	task collect_data();
		src_xtn xtn;
              	xtn = src_xtn::type_id::create("xtn");
                while(vif.src_mon.busy!==0)
			@(vif.src_mon);
		while(vif.src_mon.pkt_vld!==1)
			@(vif.src_mon);	
		xtn.header = vif.src_mon.data_in;
		xtn.payload = new[xtn.header[7:2]];
		@(vif.src_mon);
	
		for(int i=0;i<xtn.header[7:2];i++) 
		   begin
			 while(vif.src_mon.busy!==0)
			@(vif.src_mon);

			xtn.payload[i] = vif.src_mon.data_in;
			@(vif.src_mon);
	           end
		 while(vif.src_mon.busy!==0)
			@(vif.src_mon);
		while(vif.src_mon.pkt_vld!==0)
			@(vif.src_mon);	
		xtn.parity = vif.src_mon.data_in;
		repeat(2)
			@(vif.src_mon);

		`uvm_info("SRC_MON",$sformatf("data from monitor \n %s",xtn.sprint()),UVM_MEDIUM)
	endtask	

endclass
