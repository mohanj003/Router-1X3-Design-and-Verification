//Router package

package router_pkg;

	import uvm_pkg::*;

	`include "uvm_macros.svh"

	//config files
	`include "router_src_agent_config.sv"
	`include "router_dst_agent_config.sv"
	`include "router_env_config.sv"
	`include "src_xtn.sv"
	`include "dst_xtn.sv"	

	//src agent files
	`include "src_seq.sv"	
	`include "src_sequencer.sv"
	`include "src_driver.sv"
	`include "src_monitor.sv"
	`include "src_agt.sv"
	`include "router_src_agt_top.sv"

	//drv agent files
	`include "dst_seq.sv"
	`include "dst_sequencer.sv"
	`include "dst_driver.sv"
	`include "dst_monitor.sv"
	`include "dst_agt.sv"
	`include "router_dst_agt_top.sv"


	//env&test
	`include "router_env.sv"
	`include "router_test.sv"
	
endpackage
