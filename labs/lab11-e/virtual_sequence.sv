class virtual_sequence extends uvm_sequence;

    `uvm_component_utils(virtual_sequence)


    //声明sequencer句柄
    virtual_sequencer v_seqr;

    //声明相关sequence句柄
    cpu_sequence_test  cpu_sequence ;
    ahb_sequence_test  ahb_sequence ;
    apb_sequence_test  apb_sequence ;
    i2c_sequence_test  i2c_sequence ;
    uart_sequence_test uart_sequence;

    function new(string name = "",uvm_component parent);
        super.new(name,parent);
    endfunction
    
    task body();
        cpu_sequence = cpu_sequence_test::type_id::create("cpu_sequence");
        ahb_sequence = ahb_sequence_test::type_id::create("ahb_sequence");
        apb_sequence = apb_sequence_test::type_id::create("apb_sequence");;
        i2c_sequence = i2c_sequence_test::type_id::create("i2c_sequence");;
        uart_sequence= uart_sequence_test::type_id::create("uart_sequence");
        
        //做类型匹配检查
        //m_sequencer是sequence的局部变量，每个sequence都有，但视频里没讲
        if(!$cast(v_seqr,m_sequencer)) begin
            `uvm_fatal("mismatch","Virtual sequencer mismatch !!!")
        end
        
        
        //按照希望的顺序执行
        cpu_sequence.start(v_seqr.c_sequencer) ;
        ahb_sequence.start(v_seqr.h_sequencer) ;
        apb_sequence.start(v_seqr.p_sequencer) ;
        
        fork
            i2c_sequence.start(v_seqr.i_sequencer);
            uart_sequence.start(v_seqr.u_sequencer); 
        join
        
    endtask
    
endclass
