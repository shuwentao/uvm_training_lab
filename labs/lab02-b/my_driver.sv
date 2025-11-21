//一个参数化的类，指定driver所处理的transaction类型
class my_driver extends uvm_driver #(my_transaction);
    //component注册要用此宏
    `uvm_component_utils(my_driver)
    
    //parent参数，在实例化时要制定其父对象
    function new(string name = "my_driver",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual task reset_phase(uvm_phase phase);
        //下面代码不会被执行
        #100;
        phase.raise_objection(this);
        #100;
        `uvm_info("DRV_RESET_PHASE","No driver reset the DUT...",UVM_MEDIUM);
        phase.drop_objection(this);
    endtask

    virtual task configure_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100;
        `uvm_info("DRV_CONFIGURE_PHASE","Now driver config the DUT",UVM_MEDIUM)
        phase.drop_objection(this);
    endtask
    
    //需要实现driver的三个功能
    //1.获取事务 从sequencer获取transaction
    //2.分解事务 对transaction分解
    //3.驱动事务 驱动DUT
    virtual task run_phase(uvm_phase phase);
        #3000;
        //driver一般是一直工作的，所以用forever
        forever begin
            //从sequencer获取transaction，req用来引用获取到的对象，此处是my_transaction
            //req可能是在父类里面定义的？
            seq_item_port.get_next_item(req);
            
            //这里简单处理一下，直接打印
            `uvm_info("DRV_RUN_PHASE",req.sprint(),UVM_MEDIUM);
            #100;
            //通知sequencer req 处理完毕，相当于给sequencer一个相应
            seq_item_port.item_done();
        end
    endtask
endclass
