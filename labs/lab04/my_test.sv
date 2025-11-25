//`include "uvm_macros.svh"
class my_test extends uvm_test;
    
    `uvm_component_utils(my_test)
    
    my_env m_env;
    
    function new(string name = "",uvm_component parent);
        super.new(name,parent);
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
        uvm_config_db#(uvm_object_wrapper)::set(
                            this,"*.m_seqr.run_phase",
                            "default_sequence",my_sequence::get_type());

        //使用set()为控制变量item_num指定具体的值
        uvm_config_db#(int)::set(this,"*.m_seqr","item_num",20);

    endfunction
    
    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        //调用框架内部函数，打印本平台的结构
        uvm_top.print_topology(uvm_default_tree_printer);
    endfunction

endclass
