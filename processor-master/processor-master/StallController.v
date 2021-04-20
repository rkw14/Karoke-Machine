 module StallController(fd_ir,dx_ir,mult_ready,clock,stall_control,global_reset);

     input[31:0] dx_ir,fd_ir;
     input mult_ready,clock,global_reset;
     output stall_control;

     wire w1,w2,w3,w4,w5,w6,check_mult,check_div,reset_final;
     wire initial_stall_logic,check_busy,check_multdiv,write_enable;

     dffe_ref ready_val(check_busy, check_multdiv, clock, write_enable, reset_final);

     and dx_loadop(w1,~dx_ir[31],dx_ir[30],~dx_ir[29],~dx_ir[28],~dx_ir[27]);

     assign w2 = fd_ir[21:17] == dx_ir[26:22];

     assign w3 = fd_ir[16:12] == dx_ir[26:22];

     and fd_storeop(w4,~fd_ir[31],~fd_ir[30],fd_ir[29],fd_ir[28],fd_ir[27]);

     and and_1(w5,w3,~w4);
    

     or or_1(w6,w2,w5);

     and and_2(initial_stall_logic,w1,w6);

     //Want to add logic that checks if it is multdiv and if previous instruction relies on value, also need to pass in ready signal to stop stalling

     and check_mult_gate(check_mult,~dx_ir[31],~dx_ir[30],~dx_ir[29],~dx_ir[28],~dx_ir[27],~dx_ir[6],~dx_ir[5],dx_ir[4],dx_ir[3],~dx_ir[2]);
     and check_div_gate(check_div,~dx_ir[31],~dx_ir[30],~dx_ir[29],~dx_ir[28],~dx_ir[27],~dx_ir[6],~dx_ir[5],dx_ir[4],dx_ir[3],dx_ir[2]);

     or check_both(check_multdiv,check_mult,check_div);

     or write_check(write_enable,check_multdiv,mult_ready);

     or check_reset(reset_final,global_reset,mult_ready);

     or final_gate(stall_control,initial_stall_logic,check_busy,check_multdiv);




 endmodule