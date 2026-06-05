interface apb_intf(input logic pclk);
  logic preset;
  logic swrite,ptransfer,psel;
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
          srdata;
  endclocking
  
  modport drv_port(clocking drv_cb,input pclk);
  modport mon_port(clocking mon_cb,input pclk);
  
  endinterface
  
  
