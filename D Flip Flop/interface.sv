interface dff_intf(input logic clk,rst);
 
  logic d;
  logic q;
  
   clocking drv_cb @(posedge clk);
    default input #1 output #1;
    input q;
    output d;
  endclocking
  
   clocking mon_cb @(posedge clk);
    default input #0;
    input d,q;   
  endclocking
  
  modport drv_port(clocking drv_cb,input clk,rst);
  modport mon_port(clocking mon_cb,input clk,rst);  
  
endinterface
