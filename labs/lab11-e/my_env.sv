//这里简化env，省去了reference module和scoreboard等组件的连接
class my_env extends uvm_env;

    `uvm_component_utils(my_env)
    //声明reference model句柄
    my_reference_model ref_model;

    //声明scoreboard
    my_scoreboard sb;

    //声明句柄
    master_agent m_agent;
    slave_agent s_agent;

    //声明配置对象句柄
    env_config m_env_cfg;

    //
    virtual_sequencer v_seqr;

    //声明tlm fifo
    uvm_tlm_analysis_fifo#(my_transaction) r2s_fifo;
    uvm_tlm_analysis_fifo#(my_transaction) s_a2s_fifo;
    
    function new (string name = "",uvm_component parent);
        super.new(name,parent);
        this.r2s_fifo = new("r2s_fifo",this);
        this.s_a2s_fifo = new("s_a2s_fifo",this);
    endfunction

    //在build_phase中使用factory机制创造agent对象
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        //从上一层获取配置
        if(!uvm_config_db#(env_config)::get(this,"","env_cfg",m_env_cfg)) begin
            `uvm_fatal("CONFIG_FATAL","ENV can not get the configuration !!!")
        end

        //对agent进行配置
        //mst
        uvm_config_db#(agent_config)::set(this,"m_agent","m_agent_cfg",m_env_cfg.m_agent_cfg);
        //slv
        uvm_config_db#(agent_config)::set(this,"s_agent","m_agent_cfg",m_env_cfg.m_agent_cfg);

        //使用配置参数
        if(m_env_cfg.is_coverage) begin
            `uvm_info("COVERAGE_ENABLE","The function coverage is enabled for this testcase",UVM_MEDIUM)
        end

        if(m_env_cfg.is_check) begin
            `uvm_info("CHECK_ENABLE","The function check is enabled for this testcase",UVM_MEDIUM)
        end

        //实例化reference model对象
        ref_model = my_reference_model::type_id::create("ref_model",this);

        //实例化tlm fifo
        if(m_env_cfg.is_coverage) begin
            `uvm_info("COVERAGE_ENABLE","The function coverage is enabled for this testcase",UVM_MEDIUM)
        end

        if(m_env_cfg.is_check) begin
            `uvm_info("CHECK_ENABLE","The function check is enabled for this testcase",UVM_MEDIUM)
            sb = my_scoreboard::type_id::create("sb",this);
        end

        m_agent = master_agent::type_id::create("m_agent",this);
        s_agent = slave_agent::type_id::create("s_agent",this);

        v_seqr = virtual_sequencer::type_id::create();
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    
        `uvm_info("ENV","Connect the agent and reference model ...",UVM_MEDIUM)

        m_agent.m_a2r_export.connect(ref_model.i_m2r_imp);
        s_agent.s_a2s_export.connect(this.s_a2s_fifo.blocking_put_export);
        ref_model.r2s_port.connect(this.r2s_fifo.blocking_put_export);
        if(m_env_cfg.is_check) begin
            sb.r2s_port.connect(this.r2s_fifo.blocking_get_export);
            sb.s_a2s_port.connect(this.s_a2s_fifo.blocking_get_export);
        end

        v_seqr.c_sequencer = CPU_agent.c_sequencer ;
        v_seqr.h_sequencer = AHB_agent.h_sequencer ;
        v_seqr.p_sequencer = APB_agent.p_sequencer ;
        v_seqr.i_sequencer = I2C_agent.i_sequencer ;
        v_seqr.u_sequencer = uart_agent.u_sequencer ;

    endfunction
    
endclass
