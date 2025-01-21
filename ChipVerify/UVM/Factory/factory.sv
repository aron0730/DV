// Override all the objects of a particular type
set_type_override_by_type ( uvm_object_wrapper original_type,
                            uvm_object_wrapper override_type,
                            bit replace=1);

set_type_override_by_name ( string original_type_name,
                            string override_type_name,
                            bit replace=1);

// Override a type within a particular instance
set_inst_override_by_type (uvm_object_wrapper original_type,
                           uvm_object_wrapper override_type,
                           string full_inst_path);

set_inst_override_by_name (string original_type_name,
                           string override_type_name,
                           string full_inst_path);

// Method Examples
// Define a base class agent
class base_agent extends uvm_agent;
    `uvm_component_utils(base_agent)  // Macro to register type information (such as type id and factory related functions) into the UVM factory
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// Define child class that extends base agent
class child_agent extends base_agent;
    `uvm_component_utils(child_agent)
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// Environment contains the agent
class base_env extends uvm_env;
    `uvm_component(base_env);
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // 'm_agnet' is a class handle to hold base_agent
    // type class objects
    base_agent m_agent;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Use create method to request factory to return a base_agent
        // type of class object
        m_agent = base_agent::type_id::create("m_agent", this);

        // Now print the type of the object pointing to by the 'm_agent' class handle
        `uvm_info("AGENT", $sformatf("Factory returned agent of type=%s, path=%s", m_agent.get_type_name(), m_agent.get_full_name()), UVM_LOW);
    endfunction
endclass
每當請求創建 base_agent 時，工廠將返回 child_agent 的實例。
uvm_factory.set_type_override_by_type(base_agent::get_type(), child_agent::get_type());  // 每當請求創建 base_agent 時，工廠將返回 child_agent 的實例。
/* sim log :
UVM_INFO @ 0: uvm_test_top.env.AGENT [Factory returned agent of type=child_agent, path=env.m_agent]*/

module testbench;

  initial begin
    // 設置工廠覆蓋，將 base_agent 替換為 child_agent
    uvm_factory.set_type_override_by_type(base_agent::get_type(), child_agent::get_type());

    // 創建環境
    base_env env = base_env::type_id::create("env", null);

    // 執行 build_phase
    env.build_phase(null);
  end
endmodule
/* sim log :
UVM_INFO @ 0: uvm_test_top.env.AGENT [Factory returned agent of type=child_agent, path=env.m_agent] */

/*
m_agent = base_agent::type_id::create("m_agent", this);
env                      // 父元件 (base_env)
 └── m_agent             // 子元件 (base_agent 或 child_agent) */


module testbench;
  initial begin
    // 創建 base_env 並執行 build_phase
    base_env env = base_env::type_id::create("env", null);
    env.build_phase(null);

    // 查詢層次結構
    uvm_component agent = env.get_child("m_agent");
    if (agent != null) begin
      $display("Found agent: %s at path: %s", agent.get_type_name(), agent.get_full_name());
    end else begin
      $display("Agent not found");
    end
  end
endmodule


// 1. Type override by Type/Name
class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    base_env m_env;

    virtual function void build_phase(uvm_phase phase);

        // Get handle to the singleton factory instance
        uvm_factory factory = uvm_factory::get();

        super.build_phase(phase);

        // Set factory to override 'base_agent' by 'child_agent' by type
        set_type_override_by_type(base_agent::get_type(), child_agent::get_type());


    endfunction

endclass

