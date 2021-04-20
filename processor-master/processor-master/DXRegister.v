module DXRegister(data_ain,data_bin,data_aout,data_bout,pc_valin,pc_valout,i_bitsin,i_bitsout,clock,write_enable,reset);

    input[31:0] pc_valin,i_bitsin,data_ain,data_bin;
    output[31:0] pc_valout,i_bitsout,data_aout,data_bout;
    input clock,write_enable,reset;

    register PC_register(pc_valin,pc_valout,reset,write_enable,clock);
    register i_register(i_bitsin,i_bitsout,reset,write_enable,clock);
    register a_val(data_ain,data_aout,reset,write_enable,clock);
    register b_val(data_bin,data_bout,reset,write_enable,clock);



endmodule