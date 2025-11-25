//一个参数化的类，指定driver所处理的transaction类型
class my_driver extends uvm_driver #(my_transaction);
    //component注册要用此宏
    `uvm_component_utils(my_driver)
    
    //声明virtual interface句柄
    virtual dut_interface m_vif;
    
    //parent参数，在实例化时要制定其父对象
    function new(string name = "my_driver",uvm_component parent);
        super.new(name,parent);
    endfunction
    
    //在build_phase中使用uvm_config_db::get获取virtual interface
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_db#(virtual dut_interface)::get(this,"","vif",m_vif);
    endfunction
    
    virtual task pre_reset_phase(uvm_phase phase);
        super.pre_reset_phase(phase);
        `uvm_info("TRACE",$sformatf("%m"),UVM_HIGH)
        phase.raise_objection(this);
        m_vif.driver_cb.frame_n <= 'x ; 
        m_vif.driver_cb.valid_n <= 'x ;
        m_vif.driver_cb.din     <= 'x ;
        m_vif.driver_cb.reset_n <= 'x ;
        phase.drop_objection(this);
    endtask

    virtual task reset_phase(uvm_phase phase);
        super.reset_phase(phase);
        `uvm_info("TRACE",$sformatf("%m"),UVM_HIGH)
        phase.raise_objection(this);
        m_vif.driver_cb.frame_n <= '1 ; 
        m_vif.driver_cb.valid_n <= '1 ;
        m_vif.driver_cb.din     <= '0 ;
        m_vif.driver_cb.reset_n <= '1 ;
        repeat(5) @(m_vif.driver_cb);
        m_vif.driver_cb.reset_n <= '0 ;
        repeat(5) @(m_vif.driver_cb);
        m_vif.driver_cb.reset_n <= '1 ;
        phase.drop_objection(this);
    endtask

    //需要实现driver的三个功能
    //1.获取事务 从sequencer获取transaction
    //2.分解事务 对transaction分解
    //3.驱动事务 驱动DUT
    virtual task run_phase(uvm_phase phase);
        logic [7:0] temp ;
        repeat(15)@(m_vif.driver_cb);
        //driver一般是一直工作的，所以用forever
        forever begin
            //从sequencer获取transaction，req用来引用获取到的对象，此处是my_transaction
            //req可能是在父类里面定义的？
            seq_item_port.get_next_item(req);
            //这里简单处理一下，直接打印
            `uvm_info("DRV_RUN_PHASE",req.sprint(),UVM_MEDIUM);

            //send address
            m_vif.driver_cb.frame_n[req.sa] <= 1'b0 ;
            for(int i = 0 ; i < 4 ; i ++) begin
                m_vif.driver_cb.din[req.sa] <= req.da[i] ; 
                @(m_vif.driver_cb);
            end

            //Send pad
            m_vif.driver_cb.din[req.sa]     <= 1'b1 ;
            m_vif.driver_cb.valid_n[req.sa] <= 1'b1 ;
            repeat(5) @(m_vif.driver_cb);

            //Send payload
            while(!m_vif.driver_cb.busy_n[req.sa]) 
                @(m_vif.driver_cb);

            foreach(req.payload[index]) begin
                temp = req.payload[index]
                for(int i = 0 ; i < 8 ; i ++) begin
                    m_vif.driver_cb.din[req.sa]     <= temp[i] ;
                    m_vif.driver_cb.valid_n[req.sa] <= 1'b0 ; 
                    m_vif.driver_cb.frame_n[req.sa] <= ((req.payload.size()-1) == index) && (i == 7);
                    @(m_vif.driver_cb);
                end
            end
            m_vif.driver_cb.valid_n[req.sa] <= 1'b1 ;

            //通知sequencer req 处理完毕，相当于给sequencer一个相应
            seq_item_port.item_done();
        end
    endtask
endclass
