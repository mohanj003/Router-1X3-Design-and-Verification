//Destination traction

class dst_xtn extends uvm_sequence_item;

	`uvm_object_utils(dst_xtn)
	
	bit [7:0] header;
	bit [7:0]payload[];
	bit [7:0] parity;
	bit vld_out;
	rand bit [5:0]clk_cycles;

	function new(string name = "dst_xtn");
		super.new(name);
	endfunction

	function void do_print(uvm_printer printer);
		super.do_print(printer);
		printer.print_field("sim_time",$time,$bits($time),UVM_TIME);
		printer.print_field("clk_cycles",this.clk_cycles,$bits(this.clk_cycles),UVM_DEC);
		printer.print_field("header",this.header,$bits(this.header),UVM_DEC);
		foreach(payload[i])
			begin
				printer.print_field($sformatf("payload[%0d]",i),this.payload[i],$bits(this.payload[i]),UVM_DEC);
			end	
		printer.print_field("parity",this.parity,$bits(this.parity),UVM_DEC);
		printer.print_field("vld_out",this.vld_out,$bits(this.vld_out),UVM_DEC);
	endfunction

endclass
