//这个monitor仅实现每100个时间单位就打印一条信息，没有监视接口信号，也没有与其他组件进行联系
class my_monitor extends uvm_monitor;
    
    `uvm_component_utils(my_monitor)
    
    function new(string name = "",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual task reset_phase(uvm_phase phase);
        #150;
        `uvm_info("MON_RESET_PHASE","Now Monitor reset_phase running  !",UVM_MEDIUM);
    endtask

    virtual task run_phase(uvm_phase phase);
        forever begin
            `uvm_info("MON_RUN_PHASE","Monitor run!",UVM_MEDIUM);
            #100;
        end
    endtask
endclass
