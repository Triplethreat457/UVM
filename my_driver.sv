`include "my_sequence.sv"
class my_driver extends uvm_driver #(packet_item); // Alerts the packet_item is the 
virtual bus_if vif;

`uvm_component_utils(my_driver); // Alerts the UVM factory component driver exists

function new( string name = "my_driver", uvm_component parent);
super.new(name, parent);
endfunction

// Build phase is always virtual and connects the physical interface to the virtual interface
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase); // Call uvm_driverd phase function
    if (!uvm_config_db#(virtual bus_if)::get(this,"", "my_vif", vif)) begin
        `uvm_fatal("NO_VIF", "Oh no! The driver could not find 'my_vif' in the database!");
    end 
endfunction 



task run_phase(uvm_phase phase);
packet_item req; // creates 
forever begin

seq_item_port.get_next_item(req);
// sets req to have the sequence item object "req" assigned to it

// 3. Drive ALL the signals from 'req' onto the physical wires
@(posedge vif.clk);


vif.valid <= 1'b1;           
vif.address <= req.address;
vif.payload <= req.payload;

// 4. Wait one clock cycle, then de-assert valid so we don't double-write
@(posedge vif.clk);
vif.valid <= 1'b0;

// 5. Tell the sequence we are done and ready for the next item
seq_item_port.item_done();



end

endtask





endclass







