# UVM
A folder showing my progress with writing UVM testbenchs and setting a full flow, to incorporate python automation in the future.
Simple Memory UVM Testbench
This repository contains a complete, foundational Universal Verification Methodology (UVM) testbench written in SystemVerilog. It was built from scratch to verify a standard memory module using an industry-standard verification architecture.

📌 Project Overview
The Design Under Test (DUT) is a simple_memory module featuring 256 slots of 8-bit wide RAM. This testbench generates constrained-random memory transactions, drives them onto the physical hardware interface, monitors the bus for activity, and validates the hardware's behavior against physical constraints.

🏗️ UVM Architecture
This project utilizes a standard UVM structural hierarchy. All components are instantiated using the UVM Factory and communicate via standard Transaction Level Modeling (TLM) ports.

Component	File	Description
Test	my_test.sv	The top-level UVM construct that builds the environment and starts the sequence.
Environment	my_env.sv	The primary container grouping the Agent and the Scoreboard together.
Agent	my_agent.sv	An active agent encapsulating the Sequencer, Driver, and Monitor.
Scoreboard	my_scoreboard.sv	Receives packets via an Analysis Export to validate DUT constraints (e.g., address limits).
Monitor	my_monitor.sv	Passively samples the virtual interface and broadcasts transactions via an Analysis Port.
Driver	my_driver.sv	Pulls packet_items from the Sequencer and wiggles physical pins on the DUT.
🚀 Stimulus Generation
Transaction Item (packet_item.sv): A custom uvm_sequence_item containing randomizable 32-bit addresses and 8-bit payloads, protected by UVM constraints (e.g., address < 32'h1000).
Sequence (my_sequence.sv): Generates and randomizes a stream of packets, coordinating the handshake with the Driver.
🛠️ How to Run (EDA Playground)
You can easily simulate this project in the browser without a local SystemVerilog environment:
Open EDA Playground.
Paste the DUT and Interface code into design.sv.
Paste the UVM classes and the top_tb module into testbench.sv.
In the left-hand menu, configure the following:
Testbench + Design: SystemVerilog/Verilog
UVM / OVM: UVM 1.2
Tools & Simulators: Aldec Riviera Pro (or any simulator supporting UVM)
Click Run to execute the simulation and view the UVM info logs.