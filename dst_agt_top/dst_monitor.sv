//Destination monitor 

class dst_monitor extends uvm_monitor;

	`uvm_component_utils(dst_monitor)

	virtual router_if.DST_MON_MP vif;
	router_dst_agent_config dst_cfg;

	function new(string name ="dst_monitor", uvm_component parent);
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
				collected_data();
			end
	endtask
	
	task collected_data();
		dst_xtn xtn;
		xtn=dst_xtn::type_id::create("xtn");
	
		while(vif.dst_mon.read_enb!==1)
		@(vif.dst_mon);
		@(vif.dst_mon);
		xtn.header=vif.dst_mon.data_out;
		xtn.payload=new[xtn.header[7:2]];
		@(vif.dst_mon);
	
		foreach(xtn.payload[i])
   			begin
				while(vif.dst_mon.read_enb!==1)
				@(vif.dst_mon);
				xtn.payload[i]=vif.dst_mon.data_out;
				@(vif.dst_mon);
 			  end

		while(vif.dst_mon.read_enb!==1)
		@(vif.dst_mon);
		xtn.parity=vif.dst_mon.data_out;
   		repeat(2)
		@(vif.dst_mon);
		`uvm_info("DST_MONITOR",$sformatf("printing from monitor \n %s", xtn.sprint()),UVM_LOW)
	endtask

endclass
