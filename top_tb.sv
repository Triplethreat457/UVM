module top;

logic clk;
logic resetn;

// Generate  5ns period Clock
initial clk = 0;
always #5 clk = ~clk;

initial begin
resetn = 1'b0;
#20;
resetn = 1'b1;
end

// Instantiate the interface
bus_if physical_if(.clk(clk), .resetn(resetn));

// Connect the interface with the actual physical interface
simple_memory mem(physical_if);

// Upload the interface on the DUT to UVM database
initial begin
uvm_config_db#(virtual bus_if)::set(null, "*" , "my_vif", physical_if);

//start the UVM-BOSS (The test)
run_test("my_test");
end







endmodule