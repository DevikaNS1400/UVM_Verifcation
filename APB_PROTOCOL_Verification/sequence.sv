class apb_sequence extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(apb_sequence)
  
  apb_seq_item tx;
  
  function new(string name="apb_sequence");
    super.new(name);
    `uvm_info("sequence Class","constructor",UVM_MEDIUM)
  endfunction
  
  task body();
    repeat(100)begin
      tx=apb_seq_item::type_id::create("tx");
      start_item(tx);
      if(!tx.randomize())
        $fatal("Sequence","Randomization failed");
      finish_item(tx);
    end
  endtask
  
endclass
