//Router env config 

class router_env_config extends uvm_object;
	`uvm_object_utils(router_env_config)

	router_src_agent_config src_cfg[];
	router_dst_agent_config dst_cfg[];

	bit has_src_agent;
	bit has_dst_agent;

	int no_of_src_agt;
	int no_of_dst_agt;

	function new(string name="router_env_config");
		super.new(name);
	endfunction

endclass
