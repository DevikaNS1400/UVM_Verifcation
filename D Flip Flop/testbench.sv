`timescale 1ns/1ns
`include "uvm_macros.svh"
 import uvm_pkg::*;

`include "interface.sv"
`include "seq_item.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "environment.sv"
`include "test.sv"
module top;
  logic clk;
  logic rst;
  
  dff u1(.clk(intf.clk),.rst(intf.rst),.d(intf.d),.q(intf.q));
  dff_intf intf(.clk(clk),.rst(rst));
  
  initial begin
    uvm_config_db#(virtual dff_intf.drv_port)::set(null,"*","vif",intf.drv_port);
    uvm_config_db#(virtual dff_intf.mon_port)::set(null,"*","vif",intf.mon_port);
  end
  
  initial begin
    clk=0;
    rst=1'b1;#10;
    rst=1'b0;
  end
  
  always #5 clk=~clk;
  
  
  initial begin
    $monitor($time,"clk=%d",clk);
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  initial begin
    run_test("dff_test");
  end
endmodule
