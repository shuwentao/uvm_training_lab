//这里简化env，省去了reference module和scoreboard等组件的连接
class my_env extends uvm_env;

    `uvm_component_utils(my_env)
    //声明句柄
    master_agent m_agent;
    
    function new (string name = "",uvm_component parent);
        super.new(name,parent);
    endfunction
    //在build_phase中使用factory机制创造agent对象
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_agent = master_agent::type_id::create("m_agent",this);
    endfunction
    
endclass
