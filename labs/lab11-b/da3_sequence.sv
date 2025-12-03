class da3_sequence extends my_sequence;
    
    `uvm_object_utils(da3_sequence)
    //将da3_sequence注册到my_sequence_lib中
    //`uvm_add_to_seq_lib(da3_sequence,my_sequence_lib)

    function new(string name = "da3_sequence");
        super.new(name);
    endfunction

    function void pre_randomize();
        uvm_config_db#(int)::get(m_sequencer,"","item_num",item_num);
    endfunction

    virtual task body();
        my_transaction tr;
        if(starting_phase != null)
            starting_phase.raise_objection(this);
            
         repeat(item_num) begin
             //`uvm_do(req)
                tr = my_transaction::type_id::create("tr");
                start_item(tr);
                tr.randomize() with {tr.da == 3;};
                finish_item(tr);
                get_response(rsp);
                `uvm_info("SEQ",{"\n","Sequence get the response:\n",rsp.sprint()},UVM_MEDIUM);
         end
         
         #100;
         if(starting_phase != null)
             starting_phase.drop_objection(this);
     endtask
    
endclass
