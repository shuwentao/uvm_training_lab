class my_transaction extends uvm_sequence_item;
    //为激励成员制定rand属性
    rand bit [3:0] sa;
    rand bit [3:0] da;
    rand reg [7:0] payload[$];
    
    //将自定义的事务类向UVM注册
    `uvm_object_utils_begin(my_transaction)
        `uvm_field_int(sa,UVM_ALL_ON)
        `uvm_field_int(da,UVM_ALL_ON)
        `uvm_field_queue_int(payload,UVM_ALL_ON)
    `uvm_object_utils_end
    
    //约束项，控制随机成员的随机范围
    constraint Limit {
        sa inside {[0:15]};
        da inside {[0:15]};
        payload.size() inside {[2:4]};
    }

    function new(string name = "my_transaction");
        super.new(name);
    endfunction

endclass
