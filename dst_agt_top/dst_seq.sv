//destinatio sequence

class dst_seq extends uvm_sequence #(dst_xtn);

	`uvm_object_utils(dst_seq)

	rand bit [5:0]clk_cycles;

	function new(string name = "dst_seq");
		super.new(name);
	endfunction

endclass


//clock cycles less than 30

class dst_ext1_seq extends dst_seq;
	`uvm_object_utils(dst_ext1_seq)

	function new(string name="dst_ext1_seq");
		super.new(name);	
	endfunction
	
	task body();
    	    repeat(5)
	  	begin
   			req=dst_xtn::type_id::create("req");
	   		start_item(req);
   			assert(req.randomize() with {clk_cycles<30;});
	   		//`uvm_info("DST_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_MEDIUM) 
	   		finish_item(req); 
	 	end
   	endtask

endclass

//clock cycles greater than 30

class dst_ext2_seq extends dst_seq;
	`uvm_object_utils(dst_ext2_seq)

	function new(string name="dst_ext2_seq");
		super.new(name);	
	endfunction
	
	task body();
    	    repeat(10)
	  	begin
   			req=dst_xtn::type_id::create("req");
	   		start_item(req);
   			assert(req.randomize() with {clk_cycles>30;});
	   		//`uvm_info("DST_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_MEDIUM) 
	   		finish_item(req); 
	 	end
   	endtask

endclass
 
