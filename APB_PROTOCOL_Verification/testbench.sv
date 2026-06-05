`timescale 1ns/1ns
`include "uvm_macros.svh"
 import uvm_pkg::*;

`include "interface.sv"
`include "sequence_item.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "environment.sv"
`include "test.sv"
module top;
  logic pclk;
  
  apb_intf intf(.pclk(pclk));
  apb_top u1(.pclk(intf.pclk),.preset(intf.preset),.swrite(intf.swrite),.ptransfer(intf.ptransfer),.SADDR(intf.SADDR),.SWDATA(intf.SWDATA),.f_data(intf.f_data),.pready_out(intf.pready_out));
 
  assign intf.pwrite=u1.pwrite;
  assign intf.psel=u1.psel;
  assign intf.paddr=u1.paddr;
  assign intf.srdata=u1.srdata;
  
  initial begin
    uvm_config_db #(virtual apb_intf.drv_port)::set(null,"*","vif",intf.drv_port);
    uvm_config_db #(virtual apb_intf.mon_port)::set(null,"*","vif",intf.mon_port);
  end
  
  initial begin
    pclk=0;
  end
  
  always #5 pclk=~pclk;
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  initial begin
    run_test("apb_test");
  end
 
  
endmodule
