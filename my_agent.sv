class my_agent extends uvm_agent;
`uvm_component_utils(my_agent)
my_monitor mon_inst;
my_driver drv_inst;
uvm_sequencer #(packet_item) seq_inst;

function new(string name = "my_agent", uvm_component parent = null);
// Call new uvm_score
super.new(name, parent);

endfunction 

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);


seq_inst = uvm_sequencer#(packet_item)::type_id::create("seq_inst", this);
drv_inst = my_driver::type_id::create("drv_inst", this);
mon_inst = my_monitor::type_id::create("mon_inst", this );
endfunction

virtual function void connect_phase(uvm_phase phase);
//Call connect phase of uvm_agent function
super.connect_phase(phase);

// Wire your custom driver directly to the built-in UVM mailbox
drv_inst.seq_item_port.connect(seq_inst.seq_item_export);


endfunction

endclass