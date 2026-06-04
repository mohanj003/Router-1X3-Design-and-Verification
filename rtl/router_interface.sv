//Router interface 

interface router_if(input bit clock);

	logic [7:0]data_in;
	logic [7:0]data_out;
	logic read_enb;
	logic valid_out;
	logic error,busy,pkt_vld;
	logic rstn;

	//source driver 
	clocking src_drv @(posedge clock);
		default input #1 output #1;
		output data_in;
		output rstn;
		output pkt_vld;
		input busy;
		input error;
	endclocking

	//source monitor
	clocking src_mon @(posedge clock);
		default input #1 output #1;
		input data_in;
		input busy;
		input error;
		input pkt_vld;
		input rstn;
	endclocking

	//destination driver
	clocking dst_drv @(posedge clock);
		default input #1 output #1;
		output read_enb;
		input valid_out;
	endclocking

	//destination monitor
	clocking dst_mon @(posedge clock);
		default input #1 output #1;
		input read_enb;
		input data_out;
		input valid_out;
	endclocking

	//modport declaration
	modport SRC_DRV_MP (clocking src_drv);
	modport SRC_MON_MP (clocking src_mon);
	
	modport DST_DRV_MP (clocking dst_drv);
	modport DST_MON_MP (clocking dst_mon);
		
endinterface
