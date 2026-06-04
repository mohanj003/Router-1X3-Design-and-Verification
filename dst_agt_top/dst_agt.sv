//destination agent

class dst_agt extends uvm_agent;

	`uvm_component_utils(dst_agt)

	dst_monitor dst_monh;
	dst_driver dst_drvh;
	dst_sequencer dst_seqrh;

	router_dst_agent_config dst_cfg;

	function new(string name ="dst_agt", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!(uvm_config_db #(router_dst_agent_config) :: get(this,"","router_dst_agent_config",dst_cfg)))
			`uvm_fatal("D_AGT","set not configured properly")
		
		dst_monh = dst_monitor :: type_id :: create("dst_monh",this);
		
	 	if(dst_cfg.is_active)
			begin
				dst_drvh = dst_driver :: type_id :: create("dst_drvh",this);
				dst_seqrh = dst_sequencer :: type_id :: create("dst_seqrh",this);
			end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(dst_cfg.is_active)
			dst_drvh.seq_item_port.connect(dst_seqrh.seq_item_export);
	endfunction

endclass
