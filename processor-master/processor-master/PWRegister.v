module PWRegister(mult_resultin,pw_irin,pw_irout,mult_resultout,clock,write_enable,reset);

    input[31:0] mult_resultin,pw_irin;
    input clock,write_enable,reset;
    output[31:0] mult_resultout,pw_irout;

    register mult_register(mult_resultin,mult_resultout,reset,write_enable,clock);
    register i_register(pw_irin,pw_irout,reset,write_enable,clock);


endmodule