class my_transaction_da3 extends my_transaction;

    `uvm_object_utils(my_transaction_da3)

    //新加约束，将da的值固定为3
    constraint da3 { da == 3; }

    function new(string name = "my_transaction_da3");
        super.new(name);
    endfunction

endclass
