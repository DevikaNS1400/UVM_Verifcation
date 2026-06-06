class apb_driver extends uvm_driver#(apb_seq_item);
  `uvm_component_utils(apb_driver)
  
  virtual apb_intf.drv_port vif;
  
  apb_seq_item tx;
  
  function new(string name="apb_driver",uvm_component parent);
    super.new(name,parent);
    `uvm_info("driver Class","constructor",UVM_MEDIUM)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual apb_intf.drv_port)::get(this,"","vif",vif))
       `uvm_fatal("no_inif in driver","virtual interface get failed from config db");
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      `uvm_info("driver Class","run_phase",UVM_MEDIUM)
      seq_item_port.get_next_item(tx);
      drive(tx);
      seq_item_port.item_done();
    end
  endtask
  
  task drive(apb_seq_item tx);
    @(vif.drv_cb);
    vif.drv_cb.preset<=tx.preset;
    vif.drv_cb.swrite<=tx.swrite; 
    vif.drv_cb.ptransfer<=tx.ptransfer;
    vif.drv_cb.SADDR<=tx.SADDR;
    vif.drv_cb.SWDATA<=tx.SWDATA;
    if(tx.ptransfer)begin
     
      do begin
         @(vif.drv_cb);
      end while(!vif.drv_cb.pready_out);
    end
   
    @(vif.drv_cb);
    
    `uvm_info("Driver Drive",$sformatf("SADDR=%0h, SWDATA=%0h, swrite=%0h",tx.SADDR,tx.SWDATA,tx.swrite),UVM_LOW)
  endtask
  
endclass

    
    
  
