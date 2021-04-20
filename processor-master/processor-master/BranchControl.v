module BranchControl(dx_ir,is_branch,pc_value_jump,alu_lessthan,alu_notequal,comparator_signal,dx_a,initial_pc,clear_regs_branch);
    
    input[31:0] dx_ir,dx_a,initial_pc;
    input alu_lessthan,alu_notequal;
    output[31:0] pc_value_jump;
    output is_branch,comparator_signal,clear_regs_branch;
    wire j_instr,bne_instr,jal_instr,jr_instr,blt_instr,bex_instr,setx_instr,bneorbltorbex,comp_sig_1,comp_sig_2,comp_sig_3,bex_check;
    wire[31:0] pc_j,pc_bne,pc_jal,pc_jr,pc_blt,pc_bex;
    wire signed[31:0] sign_extend_t,sign_extend_n;

    and j_tt(j_instr,~dx_ir[31],~dx_ir[30],~dx_ir[29],~dx_ir[28],dx_ir[27]);
    and bne_tt(bne_instr,~dx_ir[31],~dx_ir[30],~dx_ir[29],dx_ir[28],~dx_ir[27]);
    and jal_tt(jal_instr,~dx_ir[31],~dx_ir[30],~dx_ir[29],dx_ir[28],dx_ir[27]);
    and jr_tt(jr_instr,~dx_ir[31],~dx_ir[30],dx_ir[29],~dx_ir[28],~dx_ir[27]);
    and blt_tt(blt_instr,~dx_ir[31],~dx_ir[30],dx_ir[29],dx_ir[28],~dx_ir[27]);
    and bex_tt(bex_instr,dx_ir[31],~dx_ir[30],dx_ir[29],dx_ir[28],~dx_ir[27]);
    and setx_tt(setx_instr,dx_ir[31],~dx_ir[30],dx_ir[29],~dx_ir[28],dx_ir[27]);

    // or check_branch(is_branch,j_instr,bne_instr,jal_instr,jr_instr,blt_instr,bex_instr,setx_instr);
    //Not sure about including setx
    or check_branch(is_branch,j_instr,bne_instr,jal_instr,jr_instr,blt_instr,bex_instr);
    or branch_logic(bneorbltorbex,bne_instr,blt_instr,bex_instr);

    assign bex_check = dx_a != 32'b0;

    assign comp_sig_1 = bne_instr ? alu_notequal : 1'b0;
    assign comp_sig_2 = blt_instr ? alu_lessthan : comp_sig_1;
    assign comp_sig_3 = bex_instr ? bex_check : comp_sig_2;
    assign comparator_signal = bneorbltorbex ? comp_sig_3 : 1'b1;

    and clear_reg_gate(clear_regs_branch,comparator_signal,is_branch);


    wire signed[31:0] t_temp;
    assign t_temp[31:5] = dx_ir[26:0];
    assign sign_extend_t = t_temp >>> 5;

    wire signed[31:0] n_temp;
    assign n_temp[31:15] = dx_ir[16:0];
    assign sign_extend_n = n_temp >>> 15;


    wire dummy_equal1,dummy_lessthan1,dummy_overflow1;
    wire dummy_equal2,dummy_lessthan2,dummy_overflow2;
    wire[31:0] pcval_temp,jumpalu_out;


    // alu pc_alu(initial_pc,sign_extend_n,5'b0,5'b0,pcval_temp,dummy_equal1,dummy_lessthan1,dummy_overflow1);
    // alu pc_alu2(pcval_temp,32'd1,5'b0,5'b0,jumpalu_out,dummy_equal2,dummy_lessthan2,dummy_overflow2);

    alu pc_alu(initial_pc,sign_extend_n,5'b0,5'b0,jumpalu_out,dummy_equal1,dummy_lessthan1,dummy_overflow1);


    assign pc_j = sign_extend_t;
    assign pc_jal = sign_extend_t;
    assign pc_bex = sign_extend_t;
    //Need to make sure to set dx_a correctly based on the operation being done, need this for bex and jr and blt and bne, do this by setting control signal for ctrl read reg a
    assign pc_jr = dx_a;
    assign pc_blt = jumpalu_out;
    assign pc_bne = jumpalu_out;

    wire final_pc_temp;

    wire[2:0] select_bits,select_bits_temp;

    assign select_bits_temp = bex_instr ? 3'b0 : dx_ir[29:27];
    assign select_bits = is_branch ? select_bits_temp : 3'b111;

    mux_8 selector(pc_value_jump, select_bits, pc_bex, pc_j, pc_bne, pc_jal, pc_jr, initial_pc, pc_blt, initial_pc);



endmodule