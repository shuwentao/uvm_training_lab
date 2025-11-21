
typedef uvm_sequencer#(my_transaction) my_sequencer;
class master_agent extends uvm_agent;
    
    `uvm_component_utils(master_agent)
    
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
