interface bus_if(input logic clk, input logic resetn);

    //Anything we want to be edited by the UVM write in this block with no direction

    logic valid; // drive this in driver when hanshake ready
    logic [31:0] address; // We want to randomize the address in packet_item
    logic [7:0] payload;  // We want to randomize the payloads in packet_item


endinterface

module simple_memory(bus_if vif);
    


logic [7:0] memory [0:255]; // Making memory 256 slots each 8 bits wide

always_ff @(posedge vif.clk or negedge vif.resetn) begin
    if (~vif.resetn) begin
        for(int i = 0; i < 256; i++) begin
            memory[i] = 8'h00;
        end
    end else begin
        if (vif.valid) begin 
            memory[vif.address[7:0]] = vif.payload; 
        end

    end


end









endmodule