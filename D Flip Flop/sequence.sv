class dff_sequence extends uvm_sequence#(dff_seq_item);
  `uvm_object_utils(dff_sequence)
  
  dff_seq_item tx;
  
  function new(string name="dff_sequence");
    super.new(name);
    `uvm_info("sequence Class","constructor",UVM_MEDIUM)
  endfunction
  
  task body();
    repeat(10)begin
      tx=dff_seq_item::type_id::create("tx");
      start_item(tx);
      if(!tx.randomize())
        `uvm_fatal("Sequence_RANDOMIZATION","Randomization failed")
      finish_item(tx);
    end
  endtask
  
endclass
