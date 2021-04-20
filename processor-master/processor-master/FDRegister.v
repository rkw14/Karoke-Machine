module FDRegister(pc_valin,pc_valout,i_bitsin,i_bitsout,clock,write_enable,reset);

    input[31:0] pc_valin,i_bitsin;
    output[31:0] pc_valout,i_bitsout;
    input clock,write_enable,reset;

    register PC_register(pc_valin,pc_valout,reset,write_enable,clock);
    register i_register(i_bitsin,i_bitsout,reset,write_enable,clock);









endmodule