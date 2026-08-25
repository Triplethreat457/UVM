class packet_item extends uvm_sequence_item;
rand bit [31:0] address;
rand bit [7:0] payload;
rand bit rnw;
bit [7:0] rdata; //Going to sampled after address and payload randomized

function new (string name = "packet_item");

super.new (name); // Calls the 

endfunction
constraint  addr_c {
    address < 32'h1000;
}
 // A bunch of macros alerting UVM
`uvm_object_utils_begin(packet_item);
`uvm_field_int(address, UVM_ALL_ON); //allow copy, compare, and print 
`uvm_field_int(payload, UVM_ALL_ON); // allow copy, compare, and print
`uvm_field_int(rnw, UVM_ALL_ON); // allow copy, compare, and print
`uvm_field_int(rdata,UVM_ALL_ON) //allow copy,compare, and print
`uvm_object_utils_end;

endclass