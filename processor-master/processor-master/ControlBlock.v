module ControlBlock(fd_ir,dx_ir,xm_ir,mw_ir,dx_mux,alu_op,datamem_we,regfile_we,mw_mux,check_zero_mw,check_zero_xm,sw_fd_mux);

    input[31:0] fd_ir,dx_ir,xm_ir,mw_ir;
    output[4:0] alu_op;
    output dx_mux,datamem_we,regfile_we,mw_mux,check_zero_mw,check_zero_xm,sw_fd_mux;

    wire w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12;

    and sw_truthtable_fd(w12,~fd_ir[31],~fd_ir[30],fd_ir[29],fd_ir[28],fd_ir[27]);

    and addi_truthtable_dx(w1,~dx_ir[31],~dx_ir[30],dx_ir[29],~dx_ir[28],dx_ir[27]);
    and sw_truthtable_dx(w2,~dx_ir[31],~dx_ir[30],dx_ir[29],dx_ir[28],dx_ir[27]);
    and lw_truthtable_dx(w3,~dx_ir[31],dx_ir[30],~dx_ir[29],~dx_ir[28],~dx_ir[27]);

    and addi_truthtable_xm(w5,~xm_ir[31],~xm_ir[30],xm_ir[29],~xm_ir[28],xm_ir[27]);
    and sw_truthtable_xm(w6,~xm_ir[31],~xm_ir[30],xm_ir[29],xm_ir[28],xm_ir[27]);
    and lw_truthtable_xm(w7,~xm_ir[31],xm_ir[30],~xm_ir[29],~xm_ir[28],~xm_ir[27]);

    and lw_truthtable_mw(w8,~mw_ir[31],mw_ir[30],~mw_ir[29],~mw_ir[28],~mw_ir[27]);
    and sw_truthtable_mw(w9,~mw_ir[31],~mw_ir[30],mw_ir[29],mw_ir[28],mw_ir[27]);
    and check_zeromw(w10,~mw_ir[26],~mw_ir[25],~mw_ir[24],~mw_ir[23],~mw_ir[22]);
    and check_zeroxm(w11,~xm_ir[26],~xm_ir[25],~xm_ir[24],~xm_ir[23],~xm_ir[22]);

    wire check_rtypewire;

    and check_rtype(check_rtypewire, ~mw_ir[31],~mw_ir[30],~mw_ir[29],~mw_ir[28],~mw_ir[27] );


    wire blt_instr,jr_instr,bex_instr,j_instr,bne_instr;
    and jr_tt(jr_instr,~mw_ir[31],~mw_ir[30],mw_ir[29],~mw_ir[28],~mw_ir[27]);
    and blt_tt(blt_instr,~mw_ir[31],~mw_ir[30],mw_ir[29],mw_ir[28],~mw_ir[27]);
    and bex_tt(bex_instr,mw_ir[31],~mw_ir[30],mw_ir[29],mw_ir[28],~mw_ir[27]);
    and j_tt(j_instr,~mw_ir[31],~mw_ir[30],~mw_ir[29],~mw_ir[28],mw_ir[27]);
    and bne_tt(bne_instr,~mw_ir[31],~mw_ir[30],~mw_ir[29],mw_ir[28],~mw_ir[27]);
    

    wire reg_write;
    or reg_write_gate(reg_write,w9,jr_instr,blt_instr,bex_instr,j_instr,bne_instr); 


    or final_dxmux(w4,w1,w2,w3);

    assign dx_mux = w4;
    
    //we know we can add if the dx_mux value is 1 because all the immediate operations use the alu to add the immediate value (addi,lw,sw)
    assign alu_op = w4 ? 5'b00000: dx_ir[6:2];

    assign datamem_we = w6;

    assign mw_mux = w8;

    assign regfile_we = ~reg_write;

    assign check_zero_mw = w10;

    assign check_zero_xm = w11;

    assign sw_fd_mux = w12;






endmodule