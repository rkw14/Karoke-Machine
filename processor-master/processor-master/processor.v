/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */
    //Wires for branch control
    wire is_branch,comparator_signal,clear_regs_branch;
    wire[31:0] pc_value_jump;


    //Create PC Register
    wire[31:0] PC_input, PC_output, PC_input_final;
    wire pc_we,fd_we,dx_we,xm_we,mw_we;
    wire stall_control;
    wire dummy_equal,dummy_lessthan,dummy_overflow;
    //register PC_register(PC_input,PC_output,reset,1'b1,clock);
    register PC_register(PC_input_final,PC_output,reset,~stall_control,clock);
	
    //Increment the PC by 1
    alu pc_alu(PC_output, 32'b1, 5'b0, 5'b0, PC_input, dummy_equal, dummy_lessthan, dummy_overflow);
    assign PC_input_final = clear_regs_branch ? pc_value_jump : PC_input;



    //Assigning address for ROM in order to find instruction at address
    assign address_imem = PC_output;


    //Setting up the FD register, unsure about the write enable
    wire[31:0] fd_pcout,fd_irout,fd_irin;
    // FDRegister fetchdecode(PC_input,fd_pcout,q_imem,fd_irout,clock,1'b1,reset);
    assign fd_irin = clear_regs_branch ? 32'b0 : q_imem;
    //FDRegister fetchdecode(PC_input,fd_pcout,q_imem,fd_irout,clock,~stall_control,reset);
    FDRegister fetchdecode(PC_input,fd_pcout,fd_irin,fd_irout,clock,~stall_control,reset);

    wire bne_instr,blt_instr,bex_instr,jr_instr,change_to_destination_a,change_to_source_b;
    and bne_tt(bne_instr,~fd_irout[31],~fd_irout[30],~fd_irout[29],fd_irout[28],~fd_irout[27]);
    and blt_tt(blt_instr,~fd_irout[31],~fd_irout[30],fd_irout[29],fd_irout[28],~fd_irout[27]);
    and bex_tt(bex_instr,fd_irout[31],~fd_irout[30],fd_irout[29],fd_irout[28],~fd_irout[27]);
    and jr_tt(jr_instr,~fd_irout[31],~fd_irout[30],fd_irout[29],~fd_irout[28],~fd_irout[27]);

    or set_reg_a_gate(change_to_destination_a, bne_instr,blt_instr,jr_instr);
    or set_reg_b_gate(change_to_source_b, bne_instr,blt_instr);

    //Assigning inputs to regfile using q_imem
    wire sw_fd_mux;
    wire[4:0] ctrl_readRegA1,ctrl_readRegA2,ctrl_readRegB1;
    assign ctrl_readRegA1 = bex_instr ? 5'd30 : fd_irout[21:17];
    assign ctrl_readRegA2 = change_to_destination_a ? fd_irout[26:22] : ctrl_readRegA1;
    //assign ctrl_readRegA = fd_irout[21:17];
    assign ctrl_readRegA = ctrl_readRegA2;
    //assign ctrl_readRegB = fd_irout[16:12];
    assign ctrl_readRegB1 = sw_fd_mux ? fd_irout[26:22] : fd_irout[16:12];
    assign ctrl_readRegB = change_to_source_b ? fd_irout[21:17] : ctrl_readRegB1;


    wire[31:0] dx_pcout,dx_irout,dx_aout,dx_bout,dx_irin1,dx_irin;
    assign dx_irin1 = stall_control ? 32'b0 : fd_irout;
    assign dx_irin = clear_regs_branch ? 32'b0 : dx_irin1;
    // DXRegister decodeexecute(data_readRegA,data_readRegB,dx_aout,dx_bout,fd_pcout,dx_pcout,fd_irout,dx_irout,clock,1'b1,reset);
    DXRegister decodeexecute(data_readRegA,data_readRegB,dx_aout,dx_bout,fd_pcout,dx_pcout,dx_irin,dx_irout,clock,1'b1,reset);


    wire dx_mux,datamem_we,regfile_we,mw_mux;
    wire[4:0] alu_op;

    

    //Shifting immediate value and using output from control block to determine whether to use the immediate value or not
    wire dx_bypassbwx,dx_bypassbmx;
    wire[31:0] bwx,bypass_bfinal;

    assign bwx = dx_bypassbwx ? final_data : dx_bout;
    assign bypass_bfinal = dx_bypassbmx ? xmalu_resultoutw0 : bwx;

	wire signed[31:0] shifted_immediate,final_b;
    wire signed[31:0] b_temp;
    assign b_temp[31:15] = dx_irout[16:0];
    assign shifted_immediate = b_temp >>> 15;
    assign final_b = dx_mux ? shifted_immediate : bypass_bfinal;


    //setting up alu, need to use overflow to set rstatus register later on by hardcoding truth table
    wire[31:0] alu_result;
    wire isNotEqual, isLessThan, overflow;
    wire dx_bypassawx,dx_bypassamx;
    wire[31:0] awx,final_a;

    assign awx = dx_bypassawx ? final_data : dx_aout;
    assign final_a = dx_bypassamx ? xmalu_resultoutw0 : awx;



    //Setting up multdiv module
    wire check_mult,check_div,mult_exception,mult_ready,is_multdiv;
    wire[31:0] mult_result,pw_irout,mult_resultout,mult_resultin;


    and check_mult_gate(check_mult,~dx_irout[31],~dx_irout[30],~dx_irout[29],~dx_irout[28],~dx_irout[27],~dx_irout[6],~dx_irout[5],dx_irout[4],dx_irout[3],~dx_irout[2]);
    and check_div_gate(check_div,~dx_irout[31],~dx_irout[30],~dx_irout[29],~dx_irout[28],~dx_irout[27],~dx_irout[6],~dx_irout[5],dx_irout[4],dx_irout[3],dx_irout[2]);
    or check_multdiv(is_multdiv,check_mult,check_div);
    multdiv multiply_module(final_a, final_b, check_mult, check_div, clock, mult_result, mult_exception, mult_ready);
    assign mult_resultin = mult_result;
    PWRegister pw_reg(mult_resultin,dx_irout,pw_irout,mult_resultout,clock,is_multdiv,reset);

    //Setting up alu
    alu alu_module(final_a, final_b, alu_op,dx_irout[11:7], alu_result, isNotEqual, isLessThan, overflow);

    //Setting up XMRegister
    wire[31:0] xmalu_resultout,xm_bout,xm_irout1,xm_irout,xmalu_resultoutw0,xm_pcout,xm_pcoutp1,xmalu_resultout1;
    wire check_zero_xm,jal_instr_xm;
    and jal_tt(jal_instr_xm,~xm_irout[31],~xm_irout[30],~xm_irout[29],xm_irout[28],xm_irout[27]);
    assign xmalu_resultoutw0 = check_zero_xm ? 32'b0 : xmalu_resultout1;
    wire xm_bypassbwm;
    assign xmalu_resultout = jal_instr_xm ? xm_pcout : xmalu_resultout1;
    assign xm_irout[26:22] = jal_instr_xm ? 5'b11111 : xm_irout1[26:22];
    assign xm_irout[21:0] = xm_irout1[21:0];
    assign xm_irout[31:27] = xm_irout1[31:27];
    

    wire[31:0] output_error,xm_irin1,alu_result_final1,xm_irin,alu_result_final;
    wire error_bool;
    RStatus error_check(dx_irout[31:27],alu_op,overflow,output_error,error_bool);
    // XMRegister xm_reg(alu_result,xmalu_resultout,bypass_bfinal,xm_bout,dx_irout,xm_irout,clock,1'b1,reset);
    
    assign alu_result_final1 = error_bool ? output_error : alu_result;
    assign xm_irin1[26:22] = error_bool ? 5'd30 : dx_irout[26:22];
    assign xm_irin1[21:0] = dx_irout[21:0];
    assign xm_irin1[31:27] = dx_irout[31:27];

    //Checking for setx
    wire setx_instr;
    and setx_tt(setx_instr,dx_irout[31],~dx_irout[30],dx_irout[29],~dx_irout[28],dx_irout[27]);
    wire signed[31:0] t_temp, sign_extend_t;
    assign t_temp[31:5] = dx_irout[26:0];
    assign sign_extend_t = t_temp >>> 5;

    assign xm_irin[26:22] = setx_instr ? 32'd30 : xm_irin1[26:22];
    assign xm_irin[31:27] = xm_irin1[31:27];
    assign xm_irin[21:0] = xm_irin1[21:0];

    assign alu_result_final = setx_instr ? sign_extend_t : alu_result_final1;

    XMRegister xm_reg(alu_result_final,xmalu_resultout1,dx_bout,xm_bout,xm_irin,xm_irout1,dx_pcout,xm_pcout,xm_pcoutp1,clock,1'b1,reset);

    //Setting up inputs and outputs for dmem
    assign wren = datamem_we;
    assign address_dmem = xmalu_resultout;
    assign data = xm_bypassbwm ? final_data : xm_bout;

    //Setting up MW Register
    wire[31:0] mw_aluout,mw_dataout,mw_irout;
    MWRegister mw_reg(xmalu_resultout,q_dmem,xm_irout,mw_aluout,mw_dataout,mw_irout,1'b1,clock,reset);


    //Final Steps, passing in data and destination register to Register File
    wire[31:0] final_data,final_data_temp;
    wire[4:0] regfile_destination;
    wire check_zero_mw;
    assign final_data_temp = mw_mux ? mw_dataout : mw_aluout;
    assign final_data = check_zero_mw ? 32'b0 : final_data_temp;
    assign regfile_destination = mw_irout[26:22];
    assign ctrl_writeReg = mult_ready ? pw_irout[26:22] : regfile_destination;
    assign data_writeReg = mult_ready ? mult_result : final_data;
    assign ctrl_writeEnable = regfile_we;

    ControlBlock control_signals(fd_irout,dx_irout,xm_irout,mw_irout,dx_mux,alu_op,datamem_we,regfile_we,mw_mux,check_zero_mw,check_zero_xm,sw_fd_mux);
    BypassControlBlock bypass_controls(dx_irout,xm_irout,mw_irout,dx_bypassawx,dx_bypassamx,dx_bypassbwx,dx_bypassbmx,xm_bypassbwm);
    StallController stall_controller(fd_irout,dx_irout,mult_ready,clock,stall_control,reset);
    WriteEnableController we_signals(stall_control,mult_ready,pc_we,fd_we,dx_we,xm_we,mw_we);
    BranchControl branching_control(dx_irout,is_branch,pc_value_jump,isLessThan,isNotEqual,comparator_signal,final_a,dx_pcout,clear_regs_branch);












endmodule
