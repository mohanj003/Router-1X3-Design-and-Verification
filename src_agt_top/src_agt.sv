//source agent

class src_agt extends uvm_agent;

	`uvm_component_utils(src_agt)

	src_monitor src_monh;
	src_driver src_drvh;
	src_sequencer src_seqrh;

	router_src_agent_config src_cfg;

	function new(string name ="src_agt", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!(uvm_config_db #(router_src_agent_config) :: get(this,"","router_src_agent_config",src_cfg)))
			`uvm_fatal("S_AGT","set not configured properly")
		
		src_monh = src_monitor :: type_id :: create("src_monh",this);
		
		if(src_cfg.is_active)
			begin
				src_drvh = src_driver :: type_id :: create("src_drvh",this);
				src_seqrh = src_sequencer :: type_id :: create("src_seqrh",this);
			end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(src_cfg.is_active)
			src_drvh.seq_item_port.connect(src_seqrh.seq_item_export);
	endfunction

endclass
