//参数化的类，sequence所产生的transaction的类型
class my_sequence extends uvm_sequence #(my_transaction);
    `uvm_object_utils(my_sequence)

    //添加控制变量item_num
    int item_num=10;
    
    function new(string name = "my_sequence");
        super.new(name);
    endfunction

    //使用get()获取控制变量item_num的配置
    function void pre_randomize();
        //sequence不是component,但是sequencer是component.sequence是sequencer中的一个成员
        uvm_config_db#(int)::get(m_sequencer,"","item_num",item_num);
    endfunction
    
    //body() 任务是sequence中最重要的一个方法，它的作用是控制盒产生transaction序列
    virtual task body();
        my_transaction tr;
        if(starting_phase != null)
            starting_phase.raise_objection(this);
            
         //UVM内建的宏，用来产生transaction。每调用一次产生一个transaction
         //数字10被改为item_num,用变量来控制transaction产生的数量 
         //repeat(10) begin
         repeat(item_num) begin
             //`uvm_do(req)
                tr = my_transaction::type_id::create("tr");
                start_item(tr);
                tr.randomize();
                finish_item(tr);
         end
         
         #100;
         if(starting_phase != null)
             starting_phase.drop_objection(this);
     endtask
     
endclass
