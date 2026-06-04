//Source transaction class

class src_xtn extends uvm_sequence_item;

	`uvm_object_utils(src_xtn)
	
	rand bit [7:0] header;
	rand bit [7:0]payload[];
	bit [7:0] parity;
	bit error;

	constraint valid_addr {header [1:0]!= 3;}
	constraint valid_payload {header [7:2]!= 0;}
	constraint valid_size {payload.size == header[7:2];}
	
	function new(string name = "src_xtn");
		super.new(name);
	endfunction

	function void post_randomize;
		parity = header;
		foreach(payload[i])
			parity = parity ^ payload[i];
	endfunction

	virtual function void do_print(uvm_printer printer);
		printer.print_field("header",this.header,8,UVM_DEC);
		foreach(payload[i])
			printer.print_field($sformatf("payload[%d]",i),this.payload[i],8,UVM_DEC);
		printer.print_field("error",this.error,1,UVM_DEC);
		printer.print_field("parity",this.parity,8,UVM_DEC);
	endfunction

endclass		
