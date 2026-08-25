class my_scoreboard extends uvm_scoreboard;
`uvm_component_utils(my_scoreboard)
logic [7:0] shadow_mem [int]; // Copy mem block that only updates on writes
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
if (pkt.address >= 32'h1000)  begin
//Output error
`uvm_error("SCB","FAILED PKT created outside the constriants");
end

// 3. Else, print a `uvm_info("SCB", "Packet address is valid!", UVM_LOW)
else begin
if (pkt.rnw == 1'b1) begin // if it was a read packet
if (shadow_mem.exists(pkt.address)) begin // Check if address written to before in shadow mem
        if(shadow_mem[pkt.address] != pkt.rdata) begin // unsucessful read
            `uvm_error("SCB", $sformatf("MISMATCH at Addr %0h!!!  Expected: %0h | DUT Returned: %0h", pkt.address,shadow_mem[pkt.address], pkt.rdata));
        end 
        else begin // Successful read
            `uvm_info("SCB", $sformatf("SUCCESS! DUT Simply Read and Remembered Correct rdata value of %0h at address %0h", pkt.rdata, pkt.address),UVM_LOW);
        end
end else begin
    // Edge case: Reading an address before writing anything to it
    `uvm_warning("SCB", $sformatf("Attempted READ on UNITIALIZED PAYLOAD at Address %0h", pkt.address));
end

end 
else if (pkt.rnw == 1'b0) begin // if it was a write packet
    shadow_mem[pkt.address] = pkt.payload; //Update shadow_mem
    `uvm_info("SCB",$sformatf("Recorded WRITE: Addr %0h = %0h",pkt.address,pkt.payload), UVM_LOW);
end

else begin  // if rnw is 'X' or 'Z'
     `uvm_error("SCB", $sformatf("PROTOCOL ERROR: Bus sampled invalid RNW value (%b)", pkt.rnw));
end
end




endfunction



endclass