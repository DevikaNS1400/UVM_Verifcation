class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)
  
  apb_seq_item tx;
  bit [31:0]mem[0:31];
  bit [31:0]expected_data;
  uvm_analysis_imp#(apb_seq_item,apb_scoreboard)item_collected_import;
  
  function new(string name="apb_scoreboard",uvm_component parent);
    super.new(name,parent);
    `uvm_info("scoreboard Class","constructor",UVM_MEDIUM)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);        item_collected_import=new("item_collected_import",this);
  endfunction
  
  virtual function void write(apb_seq_item tx);
    if (tx.ptransfer && tx.psel)begin
      if(tx.pwrite==1'b1 && tx.pready_out)begin
      mem[tx.SADDR[4:0]]=tx.SWDATA;
      `uvm_info("SCB Write",$sformatf("Stored data: SADDR=%0h, SWDATA=%0h mem[%0h]=%0h",tx.SADDR,tx.SWDATA,tx.SADDR,mem[tx.SADDR]),UVM_LOW)
    end
    
    else begin
      if(!tx.pwrite && tx.pready_out)begin
      expected_data=mem[tx.SADDR[4:0]];
      if(tx.f_data==expected_data)begin
        `uvm_info("SCB_PASS",$sformatf("SADDR=%0h, f_data=%0h, expected data=%0h,mem[%0h]=%0h",tx.SADDR,tx.f_data,expected_data,tx.SADDR,mem[tx.SADDR]),UVM_LOW);
      end
      
      else begin
        `uvm_error("SCB FAIL",$sformatf("SADDR=%0h, f_data=%0h, expected data=%0h",tx.SADDR,tx.f_data,expected_data));
      end
      end
      end
    end
    else begin
      `uvm_info("NO TRANSFER","No transfer occurred",UVM_LOW)
    end
    `uvm_info("END OF A TRANSFER","One transation done",UVM_LOW)
  endfunction
  
endclass
