//Router env

class router_env extends uvm_env;
	`uvm_component_utils(router_env)

	router_src_agt_top src_agt;
	router_dst_agt_top dst_agt;

	function new(string name="router_env", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		src_agt = router_src_agt_top :: type_id :: create("src_agt",this);
		dst_agt = router_dst_agt_top :: type_id :: create("dst_agt",this);
	endfunction

endclass

	























