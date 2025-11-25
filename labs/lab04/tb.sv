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
    
    //启动uvm平台
    initial begin
        run_test();
    end

endmodule
