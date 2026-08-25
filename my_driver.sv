class my_driver extends uvm_driver #(packet_item); // Alerts the packet_item is the 
virtual bus_if vif;
// Simply drives the interface and takes randomized values from Packet_item to drive
`uvm_component_utils(my_driver); // Alerts the UVM factory component driver exists

function new( string name = "my_driver", uvm_component parent = null);
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
packet_item req; // creates packet
vif.cb_drv.valid <= 1'b0;
vif.cb_drv.rnw  <= 1'b0;
forever begin

seq_item_port.get_next_item(req);
// sets req to have the sequence item object "req" assigned to it

// 3. Drive ALL the signals from 'req' onto the physical wires
@(vif.cb_drv);


vif.cb_drv.valid <= 1'b1;           
vif.cb_drv.address <= req.address;

vif.cb_drv.rnw <= req.rnw;

// Drive payload on writes but drives uninitialized on Reads
vif.cb_drv.payload <= (req.rnw == 1'b0) ? req.payload: 'x;

`uvm_info("DRV", $sformatf("Driving a %s to Addr: %0h", (req.rnw ? "READ" : "WRITE"), req.address), UVM_LOW);


// 4. Wait one clock cycle, then de-assert valid so we don't double-write
@(vif.cb_drv);
vif.cb_drv.valid <= 1'b0;

// 5. Tell the sequence we are done and ready for the next item
seq_item_port.item_done();

end

endtask





endclass







