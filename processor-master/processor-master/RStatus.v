module RStatus(opcode,opcode_alu,error,output_error,error_bool);

    input[4:0] opcode,opcode_alu;
    input error;
    output[31:0] output_error;
    output error_bool;
    wire w1,w2,w3,w4,w5,zero_op;

    and check_alu(zero_op,~opcode[4],~opcode[3],~opcode[2],~opcode[1],~opcode[0]);
    and add_check(w1,~opcode_alu[4],~opcode_alu[3],~opcode_alu[2],~opcode_alu[1],~opcode_alu[0],zero_op);
    and addi_check(w2,~opcode[4],~opcode[3],opcode[2],~opcode[1],opcode[0],zero_op);
    and sub_check(w3,~opcode_alu[4],~opcode_alu[3],~opcode_alu[2],~opcode_alu[1],opcode_alu[0],zero_op);
    and mul_check(w4,~opcode_alu[4],~opcode_alu[3],opcode_alu[2],opcode_alu[1],~opcode_alu[0],zero_op);
    and div_check(w5,~opcode_alu[4],~opcode_alu[3],opcode_alu[2],opcode_alu[1],opcode_alu[0],zero_op);

    wire[31:0] add, addi, sub, mul, div; 
    assign add = w1 ? 32'd1 : 32'd0;
    assign addi = w2 ? 32'd2 : add;
    assign sub = w3 ? 32'd3 : addi;
    assign mul = w4 ? 32'd4 : sub;
    assign div = w5 ? 32'd5 : mul;

    assign output_error = div;
    assign error_bool = error;




endmodule
