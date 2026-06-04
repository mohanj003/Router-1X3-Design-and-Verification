//Router dst agent top

class router_dst_agt_top extends uvm_env;
	`uvm_component_utils(router_dst_agt_top)

	dst_agt d_agt[];

	router_env_config env_cfg;

	router_dst_agent_config dst_cfg[];


	function new(string name="router_dst_agt_top", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!(uvm_config_db #(router_env_config) :: get(this,"","env_cfg",env_cfg)))
			`uvm_fatal("AGT_TOP","set no configured")

		d_agt = new[env_cfg.no_of_dst_agt];

		foreach(d_agt[i])
		begin
			d_agt[i] = dst_agt :: type_id :: create($sformatf("d_agt[%0d]",i),this);
			uvm_config_db #(router_dst_agent_config) :: set(this,$sformatf("d_agt[%0d]*",i),"router_dst_agent_config",env_cfg.dst_cfg[i]);
		end
	endfunction

endclass
