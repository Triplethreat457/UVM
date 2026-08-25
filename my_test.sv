class my_test extends uvm_test;
`uvm_component_utils(my_test)
my_env env_inst;

function new(string name = "my_test", uvm_component parent = null);
    super.new(name,parent);

endfunction

// Build phase create 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);

    env_inst = my_env::type_id::create("env_inst", this);

endfunction

 // run
task run_phase(uvm_phase phase);
    my_sequence seq;
    raw_sequence sz;

    // 1. Tell the simulation we are starting something important
    phase.raise_objection(this);

    // 2. Create your custom sequence (The Vinyl Record)
    seq = my_sequence::type_id::create("seq");
    sz = raw_sequence::type_id::create("sz");

// 3. Put the record on the player!
// start() seq function to pass to uvm_sequencer in as a parameter

    seq.start(env_inst.agent_inst.seq_inst);
// runs the body() task for random sequence 

// runs the body() task testing for RAW dependecies
    sz.start(env_inst.agent_inst.seq_inst);
    

// 4. Tell the simulation we are done
    phase.drop_objection(this);

endtask

endclass