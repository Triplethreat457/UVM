class my_sequencer extends uvm_sequencer #(packet_item);
`uvm_component_utils(my_sequencer)
    function new(string name = "my_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
// Thats it nothing else the base class "uvm_sequencer" handles everything



endclass