interface apb_intf(input logic pclk);
  logic preset;
  logic swrite,ptransfer,psel,penable;
  logic [31:0]SADDR;
  logic [31:0]SWDATA;
  logic [31:0]f_data;
  logic pready_out;
  logic pwrite;
  logic [31:0]paddr;
  logic [31:0]srdata;
  
 
  
  //Clocking block for driver
  clocking drv_cb @(posedge pclk);
    default input #1 output #1;
    input f_data,pready_out;
    output preset,swrite,ptransfer,SADDR,SWDATA;
  endclocking
  
  //Clocking block for monitor
  clocking mon_cb @(posedge pclk);
    default input #0;
    input preset,
          swrite,
          ptransfer,
          SADDR,
          SWDATA,
          f_data,
          pready_out,
          pwrite,
          paddr,
          psel,
          srdata,
          penable;
  endclocking
  
  modport drv_port(clocking drv_cb,input pclk);
  modport mon_port(clocking mon_cb,input pclk);
    
    
  //ASSERTIONS
   
    //Property_1
   property p_addr_stable;
     @(posedge pclk)disable iff(!preset)
     (psel && !pready_out)|=>$stable(SADDR);
   endproperty
    
    assert_addr_stable:assert property(p_addr_stable)
      `uvm_info("ADDRESS_STABLE","Address stable",UVM_LOW)
    else
      `uvm_error("ADDRESS_NOT_STABLE","Address not stable")
    
      //Property_2
      property p_wdata_stable;
     @(posedge pclk)disable iff(!preset)
        (psel && pwrite && !pready_out)|=>$stable(SWDATA);
   endproperty
    
      assert_wdata_stable:assert property(p_wdata_stable)
        `uvm_info("WRITE_DATA_STABLE","Write data stable",UVM_LOW)
    else
      `uvm_error("WRITE_DATA_STABLE","Write data not stable")
      
      //Property_3
      property access_acquired;
     @(posedge pclk)disable iff(!preset)
        (psel && !penable)|=>(penable);
   endproperty
    
      assert_access_acquired:assert property(access_acquired)
        `uvm_info("ACCESS ACQUIRED","Slave access acquired",UVM_LOW)
    else
      `uvm_error("ACCESS NOT ACQUIRED","Slave access is not acquired")
      
      //Property_4
      property slave_ready;
     @(posedge pclk)disable iff(!preset)
        (psel && penable)|->##[1:3](pready_out==1);
   endproperty
    
      assert_slave_ready:assert property(slave_ready)
        `uvm_info("SLAVE_READY","Slave is ready",UVM_LOW)
    else
      `uvm_error("SLAVE_NOT_READY","Slave is not ready")
      
      //Property_5
      property penable_clear;
     @(posedge pclk)disable iff(!preset)
        (psel && penable && pready_out)|->##[1:2](!penable);
   endproperty
    
      assert_penable_clear:assert property(penable_clear)
        `uvm_info("PENABLE_CLEAR","Penable cleared",UVM_LOW)
    else
      `uvm_error("PENABLE_NOT_CLEARED","Penable is not cleared")
      
  
      //COVERAGE
      
      covergroup apb_cg @(posedge pclk);
        option.per_instance=1;
        
        //1.RESET COVERAGE
        RESET_CP : coverpoint preset{
          bins reset_active={0};
          bins reset_inactive={1};
        }
        
        //2.WRITE/READ COVERAGE
        WRITE_READ_CP : coverpoint swrite{
          bins write={1};
          bins read={0};
        }
        
        //3.READY COVERAGE
        READY_CP : coverpoint pready_out{
          bins ready_high={1};
          bins ready_low={0};
        }
        
        //4.READY TRANSITIONS
        READY_TRANS_CP : coverpoint pready_out{
          bins low_to_high =(0=>1);
          bins high_to_low =(1=>0);
        }
        
        //5.ADDRESS COVERAGE
        ADDR_CP : coverpoint SADDR{
          bins low_addr={[32'h0000_0000:32'h0000_FFFF]};
          bins high_addr={[32'hFFFF_0000:32'hFFFF_FFFF]};
        }
        
        //6.WRITE DATA_COVERAGE
        DATA_CP : coverpoint SWDATA{
          bins low_data={[32'h0000_0000:32'h0000_FFFF]};
          bins high_data={[32'hFFFF_0000:32'hFFFF_FFFF]};
        }
        
        //7.READ DATA COVERAGE
        DATA_OUT_CP : coverpoint f_data{
          bins low_data={[32'h0000_0000:32'h0000_FFFF]};
          bins high_data={[32'hFFFF_0000:32'hFFFF_FFFF]};
        }
        
        //8. BACK TO BACK TRANSFER
        TRANS_SEQ_CP : coverpoint ptransfer{
          bins back_to_back=(1=>1);
        }
        
        //9.WRITE/READ COVERAGE
        WRITE_READ_CP_INTL : coverpoint pwrite{
          bins write={1};
          bins read={0};
        }
        //10.WRITE/READ COVERAGE
         ADDR_CP_INTL : coverpoint paddr{
          bins low_addr={[32'h0000_0000:32'h0000_FFFF]};
          bins high_addr={[32'hFFFF_0000:32'hFFFF_FFFF]};
        }
        
        //CROSS COVERAGE
        
        //11.W/R to address zones
        ADDR_X_WR : cross ADDR_CP,WRITE_READ_CP;
        
        //12.W/R to address zones internally
        ADDR_X_WRI : cross ADDR_CP_INTL,WRITE_READ_CP_INTL;
        
        //13.ADDRESS AND DATA
        ADDR_X_DATA : cross ADDR_CP, DATA_CP;
        
        //14.ADDRESS INTL AND DATA 
        ADDR_X_DATAI : cross ADDR_CP_INTL, DATA_CP;
        
        //15.READY_W/R
        READY_W_R : cross READY_CP, WRITE_READ_CP_INTL;
        
        //16.ADDRESS INTL AND W/R 
        DATA_X_W_R : cross DATA_CP, WRITE_READ_CP_INTL;
        
        //17.W/R_INTL_W/R
        W_R_X_INTL_W_R: cross WRITE_READ_CP,WRITE_READ_CP_INTL;
        
      endgroup
        
        apb_cg cg=new();
      
      endinterface
  
  
   
  
