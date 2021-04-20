module WriteEnableController(stall_control,mult_ready,pc_we,fd_we,dx_we,xm_we,mw_we);

    input stall_control,mult_ready;
    output pc_we,fd_we,dx_we,xm_we,mw_we;


    assign dx_we = mult_ready;
    assign xm_we = mult_ready;
    assign mw_we = mult_ready;

    or pc_gate(pc_we,stall_control,mult_ready);
    //or pc_gate(pc_we,stall_control,mult_ready);






endmodule