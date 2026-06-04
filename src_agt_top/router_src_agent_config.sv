 //router src agent config

class router_src_agent_config extends uvm_object;
	`uvm_object_utils(router_src_agent_config)
	
	virtual router_if vif;
	
	uvm_active_passive_enum is_active = UVM_ACTIVE;

	function new(string name="router_src_agent_config");
		super.new(name);
	endfunction

endclass
