//参数化的类，sequence所产生的transaction的类型
class my_sequence extends uvm_sequence #(my_transaction);
    `uvm_object_utils(my_sequence)
    
    function new(string name = "my_sequence");
        super.new(name);
    endfunction
    
    //body() 任务是sequence中最重要的一个方法，它的作用是控制盒产生transation序列
    virtual task body();
        if(starting_phase != null)
            starting_phase.raise_objection(this);
            
         //UVM内建的宏，用来产生transaction。每调用一次产生一个transaction
         repeat(10) begin
             `uvm_do(req)
         end
         
         #100;
         if(starting_phase != null)
             starting_phase.drop_objection(this);
     endtask
     
endclass
