class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)
  
  apb_monitor mon;
  apb_driver drv;
  apb_sequencer seqr;
  
  function new(string name="apb_agent",uvm_component parent);
    super.new(name,parent);
    `uvm_info("UVM Agent","constructor",UVM_MEDIUM);
  endfunction
  
  function void build_phase(uvm_phase phase);
    mon=apb_monitor::type_id::create("mon",this);
    drv=apb_driver::type_id::create("drv",this);
    seqr=apb_sequencer::type_id::create("seqr",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("agent Class","connect phase",UVM_MEDIUM)
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
  
  virtual function void end_of_elaboration();
    `uvm_info("agent Class","elob phase",UVM_MEDIUM)
    print();
  endfunction
  
endclass
  
  
