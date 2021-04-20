module MWRegister(mw_aluin,mw_datain,mw_irin,mw_aluout,mw_dataout,mw_irout,write_enable,clock,reset);

    input[31:0] mw_aluin,mw_datain,mw_irin;
    output[31:0] mw_aluout,mw_dataout,mw_irout;
    input write_enable,clock,reset;


    register i_register(mw_irin,mw_irout,reset,write_enable,clock);
    register alu_register(mw_aluin,mw_aluout,reset,write_enable,clock);
    register data_register(mw_datain,mw_dataout,reset,write_enable,clock);



endmodule