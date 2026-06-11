class apb_seq_item extends uvm_sequence_item;
  `uvm_object_utils(apb_seq_item)
  
  rand bit preset;
  rand bit swrite;
  rand bit ptransfer;
  rand bit psel;
  rand bit penable;
  rand bit [31:0] SADDR;
  rand bit [31:0] SWDATA;
  
  bit pready_out;
  bit [31:0]f_data;
  bit pwrite;
  
  function new(string name="apb_seq_item");
    super.new(name);
    `uvm_info("sequence_item","constructor",UVM_MEDIUM);
  endfunction
  
  //constraint reset_c{preset dist{1:=90,0:=10};}
  constraint reset_c{preset==1'b1;}
  
  constraint swrite_c{swrite dist{1:=30,0:=70};}
  
  constraint ptransfer_c{ptransfer==1;}
 // constraint ptransfer_c{ptransfer dist{1:=90,0:=10};}
  
  //constraint SADDR_c{SADDR inside{3,4,8,10};}
  
  constraint SADDR_c{
    SADDR dist{
      32'h0000_0000:=10,
      32'hFFFF_FFFF:=10,
      [32'h0000_0001 : 32'h0000_FFFF]:=40,
      [32'hFFFF_0000 : 32'hFFFF_FFFE]:=40
    };
  }
  
   constraint SWDATA_c{
    SWDATA dist{
      [32'h0000_0000 : 32'h0000_FFFF]:=50,
      [32'hFFFF_0000 : 32'hFFFF_FFFF]:=50
    };
  }
  
  function string convert2string();
    return $sformatf("preset=%0b | pwrite=%0b | ptransfer=%0b | SADDR=%0h | SWDATA=%0h | pready=%0b |psel=%0b| f_data=%0h",preset,pwrite,ptransfer,SADDR,SWDATA,pready_out,psel,f_data);
  endfunction
                         
endclass
