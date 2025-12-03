//`include "uvm_macros.svh"
class my_test extends uvm_test;
    
    `uvm_component_utils(my_test)
    
    my_env m_env;
    //加入env_cfg类
    env_config m_env_cfg;

    //声明sequence library句柄
    my_sequence_lib m_seqlib;
    
    function new(string name = "",uvm_component parent);
        super.new(name,parent);
        m_env_cfg = new("m_env_cfg");
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_env = my_env::type_id::create("m_env",this);


        //使用uvm_config机制配置agent sequencer的default_sequence
        //个人感觉是连接了sequence,相当于sequencer发送的数据类型
        //参数1：调用set的位置，这里指的是my_test
        //参数2：被配置的变量的相对路径
        //参数3：目标变量的标识符
        //参数4：变量的类型
        //不再用配置的方式配置sequence
        //uvm_config_db#(uvm_object_wrapper)::set(
        //                    this,"*.m_seqr.run_phase",
        //                    "default_sequence",my_sequence::get_type());

        //临时增加sequence
        m_seqlib = my_sequence_lib::type_id::create();
        m_seqlib.add_sequence(da3_sequence::get_type());
        m_seqlib.add_sequence(sa6_sequence::get_type());

        uvm_config_db#(uvm_sequence_base)::set(this,"*.m_seqr.run_phase","default_sequence",m_seqlib);

        //使用set()为控制变量item_num指定具体的值
        uvm_config_db#(int)::set(this,"*.m_seqr","item_num",20);

        //给m_env_config配置初值
        m_env_cfg.is_coverage = 1;
        m_env_cfg.is_check    = 1;
        m_env_cfg.m_agent_cfg.is_active = 1;
        m_env_cfg.m_agent_cfg.pad_cycles = 10;
        
        //从顶层获取virtual interface
        if(!uvm_config_db#(virtual dut_interface)::get(this,"","top_if",m_env_cfg.m_agent_cfg.m_vif)) begin
            `uvm_fatal("CONFIG_ERROR","test can not get the interface !!!") 
        end

        ////将对象配置给m_env
        uvm_config_db#(env_config)::set(
                        this,"m_env","env_cfg",m_env_cfg);

    endfunction
    
    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        //调用框架内部函数，打印本平台的结构
        uvm_top.print_topology(uvm_default_table_printer);
    endfunction

    //此处选择自动启动，所以需要将run_phase中的手动启动的代码注释掉
    //virtual task run_phase(uvm_phase phase);
    //    my_sequence m_seq;
    //    m_seq = my_sequence::type_id::create("m_seq");
    //    phase.raise_objection(this);
    //    m_seq.start(m_env.m_agent.m_seqr);
    //    phase.drop_objection(this);
    //endtask

endclass
