class apb_sequencer extends uvm_sequencer#(apb_seq_item);
  `uvm_component_utils(apb_sequencer)
  
  function new(string name="apb_sequencer",uvm_component parent);
    super.new(name,parent);
    `uvm_info("sequencer Class","constructor",UVM_MEDIUM)
  endfunction
  
endclass
