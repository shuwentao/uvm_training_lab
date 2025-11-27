typedef uvm_sequencer#(my_transaction) my_sequencer;
class master_agent extends uvm_agent;
    
    `uvm_component_utils(master_agent)

    //声明配置句柄
    agent_config m_agent_cfg;
    
    //声明句柄
    my_sequencer m_seqr ;
    my_driver    m_driv ;
    my_monitor   m_moni ;
    
    function new (string name = "",uvm_component parent);
        super.new(name,parent);
    endfunction

    //build_phase 用于创建sequencer,driver,monitor的对象
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        //从上一层获取配置
        if(!uvm_config_db#(agent_config)::get(this,"","m_agent_cfg",m_agent_cfg)) begin
            `uvm_fatal("CONFIG_FATAL","master_agent can not get the configuration !!!")
        end
        
        //使用配置的参数
        is_active = m_agent_cfg.is_active;

        uvm_config_db#(int unsigned)::set(this,"m_driv","pad_cycles",m_agent_cfg.pad_cycles);
        uvm_config_db#(virtual dut_interface)::set(this,"m_driv","vif",m_agent_cfg.m_vif);

        //给monitor添加捕获功能，给了接口后，再monitor代码中可以实现对信号的捕捉
        uvm_config_db#(virtual dut_interface)::set(this,"m_moni","vif",m_agent_cfg.m_vif);
        

        //如果是active模式，就创建 m_seqr和m_driv
        //creater参数：1.创建的名字 2.当前对象的父对象，这里就是mater_agent
        if(is_active == UVM_ACTIVE) begin
            //使用了UVM的factory机制创建对象
            m_seqr = my_sequencer::type_id::create("m_seqr",this);
            m_driv = my_driver::type_id::create("m_driv",this);
        end
            
        m_moni = my_monitor::type_id::create("m_moni",this);
    endfunction

    //connect_phase build_phase之后执行的phase
    //这里用了TLM通信机制，将m_driv和m_seqr连接起来，以实现它们之间的transaction级通信
    virtual function void connect_phase(uvm_phase phase);
        if(is_active == UVM_ACTIVE)
            m_driv.seq_item_port.connect(m_seqr.seq_item_export);
    endfunction

endclass
