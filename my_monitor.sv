class my_monitor extends uvm_monitor;
`uvm_component_utils(my_monitor)
// create blank virtual interface pointer
virtual bus_if vif;
// Create packet_item pointer named "sampled_pkt"
packet_item sampled_pkt;

// Declare the analysis port (The Megaphone) takes in packet item object
uvm_analysis_port #(packet_item) ap;
//  Later emits signal to ScoreBoard

// 2. new Consructor so the Agent can call on it to create monitor
function new(string name = "my_monitor", uvm_component parent = null);
    super.new(name,parent);
    
 // We must physically build the port in the constructor
    ap = new("ap", this);
endfunction

// 2. The Build Phase (Download from the database)
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(virtual bus_if)::get(this, "",  "my_vif", vif))
`uvm_fatal("NO_VIF", "OH no! Monitor could not find the 'my_vif' in the database");
endfunction

// 3. RUN PHASE @posdege clk if valid sample the packet and write it through "ap"
task run_phase(uvm_phase phase);
forever begin // Runs continously forvever Monitor and Driver

@(posedge vif.clk); // Wait for one clk edge only sample on clk edges

if (vif.valid == 1) begin  
    
    // 3. We saw a valid transaction! Create a blank packet to hold the data
    
    sampled_pkt = packet_item::type_id::create("sampled_pkt");

    // 4. Assign the payload and address to the sampled_pkt from the interface
    sampled_pkt.address = vif.address;
    sampled_pkt.payload = vif.payload; 
   
    `uvm_info("MON",$sformatf("Monitor captured a packet!\nAddress:%0h\nPayload:%0h",vif.address,vif.payload), UVM_LOW);
  
    // 6. Broadcast the packet out the megaphone to the Scoreboard! through the sampled pkt
    ap.write(sampled_pkt);
end 
end 


endtask

endclass