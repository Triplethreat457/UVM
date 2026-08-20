class my_sequence extends uvm_sequence #(packet_item); //
`uvm_object_utils(my_sequence)

function new(string name = "my_sequence"); // Constructor 
    super.new(name);
endfunction

task body();  // A body that generates 3 packet_items in a sequence and randomizes starts handshake for driver
packet_item req; // Create an empty "packet-item" handle [pointer] named "req"
for(int i = 0; i < 3; ++i) begin
    req = packet_item::type_id::create("req"); // It will call packet item constructor
     //Calls new() constructor in Packet_item class and alerts UVM Factory name is "req"

    
// Handshake : the process of Sequence passes an Sequence item (transaction) to the Driver to translate to signals on DUT
   
   
start_item(req); // Wait for Driver to be ready for sequence item in handshake
    if(!req.randomize()) begin // Randomizes the Transaction object members (math solver:constraints)
    `uvm_error("SEQ", "Randomization failed!");
    // The type of error is SEQ which is SEQUENCE and the STRING PRINTED is followed
    // Factory error!!!!
    end

    finish_item(req); // SEND TO DRIVER

    /*  -- body does things
   
   1. Creates empty pointer "req"
   
   2.  In a cycle of 3 times: {
   
   3.  Assigns a Packet_item pointer "req" to a newly created Packet_item object created by type_id

   4. Calls start_item(req) to wait for Driver to finish processing its last transaction object

   5. Randomizes req item using .randomize() and prints UVM-ERROR if it fails the constraints

   6. Calls finish_item to send randomized transaction object to Driver

    }
    */


end

endtask








endclass