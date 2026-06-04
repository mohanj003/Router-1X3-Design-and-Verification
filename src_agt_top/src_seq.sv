//source sequence class

class src_sequence extends uvm_sequence #(src_xtn);

	`uvm_object_utils(src_sequence)

	function new(string name = "src_sequence");
		super.new(name);
	endfunction

endclass

//------------------------------------smal packet----------------------------------------//
class small_pkt extends src_sequence;
	
	`uvm_object_utils(small_pkt)

	bit [1:0] addr;

	function new(string name = "small_pkt");
		super.new(name);
	endfunction

	task body();
	 repeat(10)
	   begin	
		req = src_xtn :: type_id :: create("req");
		
		if(!(uvm_config_db #(bit[1:0]) :: get(null,get_full_name(),"bit[1:0]",addr)))
			`uvm_fatal("SRC_SMALL","set not configured")

		start_item(req);
		assert(req.randomize() with {header[7:2] inside {[1:14]}; header[1:0] == addr;});
		finish_item(req);
	   end
	endtask

endclass

//------------------------------------medium packet----------------------------------------//
class medium_pkt extends src_sequence;
	
	`uvm_object_utils(medium_pkt)

	bit [1:0] addr;

	function new(string name = "medium_pkt");
		super.new(name);
	endfunction

	task body();
	  repeat(10)
	     begin
		req = src_xtn :: type_id :: create("req");
		
		if(!(uvm_config_db #(bit[1:0]) :: get(null,get_full_name(),"bit[1:0]",addr)))
			`uvm_fatal("SRC_MEDIUM","set not configured")

		start_item(req);
		assert(req.randomize() with {header[7:2] inside {[15:45]}; header[1:0] == addr;});
		finish_item(req);
	      end
	endtask

endclass

//------------------------------------large packet----------------------------------------//
class large_pkt extends src_sequence;
	
	`uvm_object_utils(large_pkt)

	bit [1:0] addr;

	function new(string name = "large_pkt");
		super.new(name);
	endfunction

	task body();
	 repeat(10)
	   begin
		req = src_xtn :: type_id :: create("req");
		
		if(!(uvm_config_db #(bit[1:0]) :: get(null,get_full_name(),"bit[1:0]",addr)))
			`uvm_fatal("SRC_LARGE","set not configured")

		start_item(req);
		assert(req.randomize() with {header[7:2] inside {[46:63]}; header[1:0] == addr;});
		finish_item(req);
	   end
	endtask

endclass
