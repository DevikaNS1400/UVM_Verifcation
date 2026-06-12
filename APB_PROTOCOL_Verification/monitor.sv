class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)
  
  virtual apb_intf.mon_port vif;
 // apb_seq_item tx;
  
  uvm_analysis_port#(apb_seq_item)item_collected_port;
  
  function new(string name="apb_monitor",uvm_component parent);
    super.new(name,parent);
    `uvm_info("monitor Class","constructor",UVM_MEDIUM)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_port=new("item_collected_port",this);
    
    if(!uvm_config_db #(virtual apb_intf.mon_port)::get(this,"","vif",vif))
      `uvm_fatal("no_inif in monitor","virtual interface get failed from config db");
    
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      apb_seq_item tx;
      @(vif.mon_cb);  
  if(vif.mon_cb.psel && vif.mon_cb.pready_out)begin
      
          tx=apb_seq_item::type_id::create("tx");
          tx.preset=vif.mon_cb.preset;
          tx.swrite=vif.mon_cb.swrite;
          tx.ptransfer=vif.mon_cb.ptransfer;
          tx.psel=vif.mon_cb.psel; 
          tx.SADDR=vif.mon_cb.paddr;
          tx.pwrite=vif.mon_cb.pwrite;
          tx.penable=vif.mon_cb.penable;
          tx.pready_out=vif.mon_cb.pready_out;
    
        if(tx.pwrite)begin
          tx.SWDATA=vif.mon_cb.SWDATA;
          tx.f_data=0;
           item_collected_port.write(tx);
        `uvm_info("Monitor ",tx.convert2string(),UVM_NONE);
        end
        else begin
              automatic apb_seq_item delyd_tx=tx;
          @(vif.mon_cb);
          @(vif.mon_cb);
          @(vif.mon_cb);
          delyd_tx.f_data=vif.mon_cb.f_data;
              item_collected_port.write(delyd_tx);
              `uvm_info("Monitor ",delyd_tx.convert2string(),UVM_NONE);
        end
      end
    end
  endtask
   
endclass
