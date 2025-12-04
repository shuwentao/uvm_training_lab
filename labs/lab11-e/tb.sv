`include "uvm_macros.svh"

import uvm_pkg::*;
//`include "my_transaction.sv"
//`include "my_sequence.sv"
//`include "my_driver.sv"
//`include "my_monitor.sv"
//`include "master_agent.sv"
//`include "my_env.sv"
//`include "my_test.sv"

module tb();
    
    //这里将以上的代码用`include ""的方式包含进来

    bit sys_clk ;
    //实例化interface
    dut_interface inf(sys_clk);

    //实例化DUT,并将其端口与interface连接
    router dut(
        .reset_n    ( inf.reset_n   ), 
        .clock      ( inf.clk       ),
        .frame_n    ( inf.frame_n   ),
        .valid_n    ( inf.valid_n   ),
        .din        ( inf.din       ),
        .dout       ( inf.dout      ),
        .busy_n     ( inf.busy_n    ),
        .valido_n   ( inf.valido_n  ),
        .frameo_n   ( inf.frameo_n  ) 
    );

    initial
        begin
            uvm_config_db#(virtual dut_interface)::set(null,"uvm_test_top","top_if",inf);
        end


    initial
        begin
            sys_clk = 1'b0 ;
            forever #10 sys_clk = ~ sys_clk;
        end
    
    //启动uvm平台
    initial begin
        run_test();
    end

    initial
        begin
            $vcdpluson();
        end

endmodule
