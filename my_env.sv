class my_env extends uvm_env;
`uvm_component_utils(my_env)

// 1. Declare handles to the components inside the environment
my_agent      agent_inst;
my_scoreboard sb_inst;

function new(string name = "my_env", uvm_component parent = null);
super.new(name, parent);
endfunction

// 2. Build Phase: Instantiate the components
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);

agent_inst = my_agent::type_id::create("agent_inst", this);
sb_inst = my_scoreboard::type_id::create("sb_inst", this);

endfunction

// 3. Connect Phase: Wire them together
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);


agent_inst.mon_inst.ap.connect(sb_inst.ap_export);
endfunction








endclass