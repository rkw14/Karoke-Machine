module XMRegister(alu_resultin,alu_resultout,b_in,b_out,xm_irin,xm_irout_final,xm_pcin,xm_pcout,xm_pcoutp1,clock,write_enable,reset);

    input[31:0] alu_resultin,b_in,xm_irin,xm_pcin;
    input clock,write_enable,reset;
    output [31:0] alu_resultout,b_out,xm_irout_final,xm_pcout,xm_pcoutp1;
    wire[31:0] xm_irout;
    wire is_multdiv,check_mult,check_div;
    wire dummy_equal2,dummy_lessthan2,dummy_overflow2;

    and check_mult_gate(check_mult,~xm_irout[31],~xm_irout[30],~xm_irout[29],~xm_irout[28],~xm_irout[27],~xm_irout[6],~xm_irout[5],xm_irout[4],xm_irout[3],~xm_irout[2]);
    and check_div_gate(check_div,~xm_irout[31],~xm_irout[30],~xm_irout[29],~xm_irout[28],~xm_irout[27],~xm_irout[6],~xm_irout[5],xm_irout[4],xm_irout[3],xm_irout[2]);
    or check_multdiv(is_multdiv,check_mult,check_div);

    register i_register(xm_irin,xm_irout,reset,write_enable,clock);
    register alu_register(alu_resultin,alu_resultout,reset,write_enable,clock);
    register b_register(b_in,b_out,reset,write_enable,clock);
    register pc_register(xm_pcin,xm_pcout,reset,write_enable,clock);

    alu pc_alu2(xm_pcout,32'd1,5'b0,5'b0,xm_pcoutp1,dummy_equal2,dummy_lessthan2,dummy_overflow2);

    assign xm_irout_final = is_multdiv ? 32'b0 : xm_irout;
    


endmodule