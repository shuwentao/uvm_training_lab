class my_test_count extends my_test;

    
    `uvm_component_utils(my_test_count)

    function new(string name = "" ,uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //使用my_test_type_da3替换掉my_transaction,注意替换是在build phase中进行的
        set_type_override_by_type(my_driver::get_type(),my_driver_count::get_type());
    endfunction

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        factory.print();
    endfunction

endclass
