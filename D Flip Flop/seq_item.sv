class dff_seq_item extends uvm_sequence_item;
  `uvm_object_utils(dff_seq_item)
  
 
  rand bit d;
  bit q;
  
  function new(string name="dff_seq_item");
    super.new(name);
    `uvm_info("sequence item Class","constructor",UVM_MEDIUM)
  endfunction
  
  
  
  
  function string convert2string();
    return $sformatf(" d=%0b | q=%0b",d,q);
  endfunction
endclass
