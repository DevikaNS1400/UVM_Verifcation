class dff_env extends uvm_env;
  `uvm_component_utils(dff_env)
  dff_agent agent;
  dff_scoreboard scb;
  
  function new(string name="dff_env",uvm_component parent);
    super.new(name,parent);
    `uvm_info("env Class", "constructor",UVM_MEDIUM)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent=dff_agent::type_id::create("agent",this);
    scb=dff_scoreboard::type_id::create("scb",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("env Class", "connect phase",UVM_MEDIUM);
    agent.mon.item_collected_port.connect(scb.item_collected_import);
  endfunction
  
endclass
