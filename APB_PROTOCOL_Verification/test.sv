class apb_test extends uvm_test;
  `uvm_component_utils(apb_test)
  
  apb_env env;
  apb_sequence seq;
  
  function new(string name="apb_test",uvm_component parent);
    super.new(name,parent);
    `uvm_info("Test Class","constructor",UVM_MEDIUM)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env=apb_env::type_id::create("env",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("Test Class","connect phase",UVM_MEDIUM)
  endfunction
  
  task run_phase(uvm_phase phase);
    `uvm_info("test Class","run_phase",UVM_MEDIUM)
    phase.raise_objection(this);
    seq=apb_sequence::type_id::create("seq");
    seq.start(env.agent.seqr);
    phase.drop_objection(this);

    $display("====================================================");
    $display("FINAL FUNCTIONAL COVERAGE VALUE = %0.2f%%",top.intf.cg.get_inst_coverage());
    $display("====================================================");
  endtask
  
endclass
  
