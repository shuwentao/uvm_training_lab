//这里简化env，省去了reference module和scoreboard等组件的连接
class my_env extends uvm_env;

    `uvm_component_utils(my_env)
    //声明reference model句柄
    my_reference_model ref_model;

    //声明tlm fifo
    uvm_tlm_analysis_fifo #(my_transaction) magt2ref_fifo;

    //声明句柄
    master_agent m_agent;

    //声明配置对象句柄
    env_config m_env_cfg;
    
    function new (string name = "",uvm_component parent);
        super.new(name,parent);
        magt2ref_fifo = new("magt2ref",this);
    endfunction

    //在build_phase中使用factory机制创造agent对象
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        //从上一层获取配置
        if(!uvm_config_db#(env_config)::get(this,"","env_cfg",m_env_cfg)) begin
            `uvm_fatal("CONFIG_FATAL","ENV can not get the configuration !!!")
        end

        //对agent进行配置
        uvm_config_db#(agent_config)::set(this,"m_agent","m_agent_cfg",m_env_cfg.m_agent_cfg);

        //使用配置参数
        if(m_env_cfg.is_coverage) begin
            `uvm_info("COVERAGE_ENABLE","The function coverage is enabled for this testcase",UVM_MEDIUM)
        end

        if(m_env_cfg.is_check) begin
            `uvm_info("CHECK_ENABLE","The function check is enabled for this testcase",UVM_MEDIUM)
        end

        m_agent = master_agent::type_id::create("m_agent",this);

        //实例化reference model对象
        ref_model = my_reference_model::type_id::create("ref_model",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    
        `uvm_info("ENV","Connect the agent to tlm fifo ...",UVM_MEDIUM)
        m_agent.m_a2r_export.connect(this.magt2ref_fifo.blocking_put_export);

        `uvm_info("ENV","Connect the ref model to tlm fifo ...",UVM_MEDIUM)
        ref_model.i_m2r_port.connect(this.magt2ref_fifo.blocking_get_export);
        
    endfunction
    
endclass
