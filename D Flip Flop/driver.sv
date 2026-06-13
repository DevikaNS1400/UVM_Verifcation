class dff_driver extends uvm_driver#(dff_seq_item);
  `uvm_component_utils(dff_driver)
  
  virtual dff_intf.drv_port vif;
  dff_seq_item tx;
  
  function new(string name="dff_driver",uvm_component parent);
    super.new(name,parent);
    `uvm_info("driver Class","constructor",UVM_MEDIUM)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dff_intf.drv_port)::get(this,"","vif",vif))
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
       
       task drive(dff_seq_item tx);
         @(vif.drv_cb);
         // vif.drv_cb.rst<=tx.rst;
         vif.drv_cb.d<=tx.d;
         `uvm_info("Driver Drive",$sformatf(" d=%0b",tx.d),UVM_LOW)
       endtask
  
endclass
