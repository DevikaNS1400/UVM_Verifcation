class dff_monitor extends uvm_monitor;
  `uvm_component_utils(dff_monitor)
  
  virtual dff_intf.mon_port vif;
  uvm_analysis_port#(dff_seq_item) item_collected_port;
     dff_seq_item tx;
             
  
  function new(string name="dff_monitor",uvm_component parent);
    super.new(name,parent);

    `uvm_info("monitor Class","constructor",UVM_MEDIUM)
  endfunction
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_port=new("item_collected_port",this);
    
    if(!uvm_config_db#(virtual dff_intf.mon_port)::get(this,"","vif",vif))
      `uvm_fatal("no_inif in monitor","virtual interface get failed from config db");
    
  endfunction
                     
 task run_phase(uvm_phase phase);
   forever begin 
     @(vif.mon_cb);
     tx=dff_seq_item::type_id::create("tx",this);
     tx.d=vif.mon_cb.d;
     tx.q=vif.mon_cb.q;
     item_collected_port.write(tx);
    `uvm_info("Monitor ",tx.convert2string(),UVM_NONE);
   end
 endtask
                         
endclass
