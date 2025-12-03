class my_sequence_lib extends uvm_sequence_library#(my_transaction);
    
    `uvm_object_utils(my_sequence_lib)
    //注册该sequence library
    `uvm_sequence_library_utils(my_sequence_lib)

    function new(string name = "my_sequence_lib");
        super.new(name);
        //在该sequence library被实例化的时候，需要调用该函数初始化该sequence library
        init_sequence_library();
    endfunction

endclass
