// Router src agent top

class router_src_agt_top extends uvm_env;
	`uvm_component_utils(router_src_agt_top)

	src_agt s_agt[];
	router_env_config env_cfg;
	router_src_agent_config src_cfg[];


	function new(string name="router_src_agt_top", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!(uvm_config_db #(router_env_config) :: get(this,"","env_cfg",env_cfg)))
			`uvm_fatal("AGT_TOP","set no configured")

		s_agt = new[env_cfg.no_of_src_agt];

		foreach(s_agt[i])
		begin
			s_agt[i] = src_agt :: type_id :: create($sformatf("s_agt[%0d]",i),this);
			uvm_config_db #(router_src_agent_config) :: set(this,"*","router_src_agent_config",env_cfg.src_cfg[i]);
		end
	endfunction

endclass

