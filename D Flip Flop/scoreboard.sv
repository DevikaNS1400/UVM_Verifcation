class dff_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(dff_scoreboard)
  
  uvm_analysis_imp#(dff_seq_item,dff_scoreboard)item_collected_import;
  
  function new(string name="dff_scoreboard",uvm_component parent);
    super.new(name,parent);
    `uvm_info("scoreboard Class","constructor",UVM_MEDIUM)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_import=new("item_collected_import",this);
  endfunction
  
  virtual function void write(dff_seq_item tx);
  
      if(tx.d==tx.q)begin
        `uvm_info("scoreboard Class",".....PASS.....",UVM_MEDIUM)
      end
      else
        `uvm_error("scoreboard Class",".....FAIL.....")
    
  endfunction
  
endclass
