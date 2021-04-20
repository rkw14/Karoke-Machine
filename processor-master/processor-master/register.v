module register(input_data,output_data,clear,write_enable,clock);

    input[31:0] input_data;
    output[31:0] output_data;
    input clear;
    input write_enable;
    input clock;

    dffe_ref flip0(output_data[0], input_data[0], clock, write_enable, clear);   
    dffe_ref flip1(output_data[1], input_data[1], clock, write_enable, clear);   
    dffe_ref flip2(output_data[2], input_data[2], clock, write_enable, clear);   
    dffe_ref flip3(output_data[3], input_data[3], clock, write_enable, clear);   
    dffe_ref flip4(output_data[4], input_data[4], clock, write_enable, clear);   
    dffe_ref flip5(output_data[5], input_data[5], clock, write_enable, clear);   
    dffe_ref flip6(output_data[6], input_data[6], clock, write_enable, clear);   
    dffe_ref flip7(output_data[7], input_data[7], clock, write_enable, clear);   
    dffe_ref flip8(output_data[8], input_data[8], clock, write_enable, clear);   
    dffe_ref flip9(output_data[9], input_data[9], clock, write_enable, clear);   
    dffe_ref flip10(output_data[10], input_data[10], clock, write_enable, clear);
    dffe_ref flip11(output_data[11], input_data[11], clock, write_enable, clear);
    dffe_ref flip12(output_data[12], input_data[12], clock, write_enable, clear);
    dffe_ref flip13(output_data[13], input_data[13], clock, write_enable, clear);
    dffe_ref flip14(output_data[14], input_data[14], clock, write_enable, clear);
    dffe_ref flip15(output_data[15], input_data[15], clock, write_enable, clear);
    dffe_ref flip16(output_data[16], input_data[16], clock, write_enable, clear);
    dffe_ref flip17(output_data[17], input_data[17], clock, write_enable, clear);
    dffe_ref flip18(output_data[18], input_data[18], clock, write_enable, clear);
    dffe_ref flip19(output_data[19], input_data[19], clock, write_enable, clear);
    dffe_ref flip20(output_data[20], input_data[20], clock, write_enable, clear);
    dffe_ref flip21(output_data[21], input_data[21], clock, write_enable, clear);
    dffe_ref flip22(output_data[22], input_data[22], clock, write_enable, clear);
    dffe_ref flip23(output_data[23], input_data[23], clock, write_enable, clear);
    dffe_ref flip24(output_data[24], input_data[24], clock, write_enable, clear);
    dffe_ref flip25(output_data[25], input_data[25], clock, write_enable, clear);
    dffe_ref flip26(output_data[26], input_data[26], clock, write_enable, clear);
    dffe_ref flip27(output_data[27], input_data[27], clock, write_enable, clear);
    dffe_ref flip28(output_data[28], input_data[28], clock, write_enable, clear);
    dffe_ref flip29(output_data[29], input_data[29], clock, write_enable, clear);
    dffe_ref flip30(output_data[30], input_data[30], clock, write_enable, clear);
    dffe_ref flip31(output_data[31], input_data[31], clock, write_enable, clear);



endmodule