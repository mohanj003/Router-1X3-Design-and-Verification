//Router test

class router_test extends uvm_test;
	`uvm_component_utils(router_test)
	
	router_src_agent_config src_cfg[];
	router_dst_agent_config dst_cfg[];

	router_env envh;
	router_env_config env_cfg;
	
	int no_of_src_agt = 1;
	int no_of_dst_agt = 3;

	bit has_src_agent = 1;
	bit has_dst_agent = 1;

	function new(string name= "router_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env_cfg = router_env_config :: type_id :: create("env_cfg");
		
		//Source agent
		if(has_src_agent)
		  begin
			src_cfg = new[no_of_src_agt];
			env_cfg.src_cfg = new[no_of_src_agt];
			foreach(src_cfg[i])
			begin
				src_cfg[i] = router_src_agent_config :: type_id :: create($sformatf("src_cfg[%0d]",i));

				if(!(uvm_config_db #(virtual router_if) :: get(this,"",$sformatf("src_if%0d",i),src_cfg[i].vif)))
					`uvm_fatal("ROUTER_TEST_SRC","set not configured")

				env_cfg.src_cfg[i] = src_cfg[i];
			end
			env_cfg.has_src_agent = has_src_agent;
			env_cfg.no_of_src_agt = no_of_src_agt;			
		  end
		//Destination agent
		if(has_dst_agent)
		  begin
			dst_cfg = new[no_of_dst_agt];
			env_cfg.dst_cfg = new[no_of_dst_agt];			
			foreach(dst_cfg[i])
			begin
				dst_cfg[i] = router_dst_agent_config :: type_id :: create($sformatf("dst_cfg[%0d]",i));

				if(!(uvm_config_db #(virtual router_if) :: get(this,"",$sformatf("dst_if%0d",i),dst_cfg[i].vif)))
					`uvm_fatal("ROUTER_TEST_DST","set not configured")

				env_cfg.dst_cfg[i] = dst_cfg[i];
			end
			env_cfg.has_dst_agent = has_dst_agent;
			env_cfg.no_of_dst_agt = no_of_dst_agt;
		  end

		uvm_config_db #(router_env_config) :: set(this, "*","env_cfg",env_cfg);

		envh = router_env :: type_id :: create("envh",this);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction	

endclass

//----------------------------small test-------------------------------//
class small_test extends router_test;

	`uvm_component_utils(small_test)
	small_pkt sph;
	dst_ext1_seq dsth;
	bit [1:0]addr;
	
	function new(string name ="small_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		sph = small_pkt :: type_id :: create("sph");
		dsth = dst_ext1_seq :: type_id :: create ("dsth");
		addr = $random %3;
		uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
		phase.raise_objection(this);
		fork
		sph.start(envh.src_agt.s_agt[0].src_seqrh);
		dsth.start(envh.dst_agt.d_agt[addr].dst_seqrh);
		join
                #100;
		phase.drop_objection(this);
	endtask

endclass

//----------------------------medium test-------------------------------//
class medium_test extends router_test;

	`uvm_component_utils(medium_test)
	medium_pkt mph;
	bit [1:0]addr;
	
	function new(string name ="medium_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		mph = medium_pkt :: type_id :: create("mph");
		addr = $random %3;
		uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
		phase.raise_objection(this);
		mph.start(envh.src_agt.s_agt[0].src_seqrh);
		#100;
		phase.drop_objection(this);
	endtask

endclass

//----------------------------large test-------------------------------//
class large_test extends router_test;

	`uvm_component_utils(large_test)
	large_pkt lph;
	bit [1:0]addr;
	
	function new(string name ="large_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		lph = large_pkt :: type_id :: create("mph");
		addr = $random %3;
		uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
		phase.raise_objection(this);
		lph.start(envh.src_agt.s_agt[0].src_seqrh);
		#50;
		phase.drop_objection(this);
	endtask

endclass
