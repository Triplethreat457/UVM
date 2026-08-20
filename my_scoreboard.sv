class my_scoreboard extends uvm_scoreboard;
`uvm_component_utils(my_scoreboard)

// The receiver (microphone) for the Monitor's megaphone
// Notice it takes TWO parameters: the transaction type, and the parent class type
uvm_analysis_imp #(packet_item, my_scoreboard) ap_export;
function new(string name = "my_scoreboard", uvm_component parent = null);
// Call uvm_scoreboard constructor
super.new(name,parent);



endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
// Build the export port
ap_export = new("ap_export", this);
endfunction
// This function is triggered AUTOMATICALLY by the Monitor's ap.write()
virtual function void write(packet_item pkt);
// if the packet communicated from the montior is outside the constriants
if (pkt.address > 32'h1000)  begin
//Output error
`uvm_error("SCB","FAILED PKT created outside the constriants");

end

// 3. Else, print a `uvm_info("SCB", "Packet address is valid!", UVM_LOW)
else begin
`uvm_info("SCB", $sformatf("Success: Packet passed in Scoreboard Constriants"),UVM_LOW );
end




endfunction



endclass