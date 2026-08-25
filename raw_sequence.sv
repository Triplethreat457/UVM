class raw_sequence extends uvm_sequence#(packet_item);

`uvm_object_utils(raw_sequence)
function new(string name = "raw_sequence");
    super.new(name);
endfunction

task body();
packet_item raw_item;
bit [31:0] saved_address;
repeat(5) begin //Generate a Sequence of 5 RAW items
    
    // create raw item
    raw_item = packet_item::type_id::create("raw_item");
    /*
    ==========================================
     THE WRITE TRANSACTION
    ==========================================
    */
    start_item(raw_item); // Wait for Driver to call item_done()
    if(!raw_item.randomize() with {address < 32'h1000; rnw == 1'b0;}) begin
        `uvm_error("SEQ","Write randomization failed!");
    end

    // save the address to read after
    saved_address = raw_item.address;

    `uvm_info("SEQ", $sformatf("Generated WRITE to Address: %0h", saved_address), UVM_LOW);
   
    finish_item(raw_item); // Packet is randomized so send it driver 

    /*
    ==========================================
     THE READ TRANSACTION
    ==========================================
    
    */
    // Create empty packet_item to get ready to read
    raw_item = packet_item::type_id::create("raw_item");

    start_item(raw_item);
// Randomize read transaction with constraints for rnw ==1'b1 for read 
    if(!raw_item.randomize() with {address == saved_address; rnw == 1'b1;}) begin
    `uvm_error("SEQ",$sformatf("READ randomization failed!"));
    end 

    finish_item(raw_item);
    `uvm_info("SEQ", $sformatf("Generated READ to Address: %0h", saved_address), UVM_LOW);
end // end repeat 5

    `uvm_info("SEQ", "RAW Sequence Complete!", UVM_LOW)


endtask

endclass