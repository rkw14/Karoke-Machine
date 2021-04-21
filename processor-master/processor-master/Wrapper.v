`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (clock, reset,micData,switches,micClk,chSel,audioOut,audioEn,Anode_Activate,LED_out,
hSync,vSync,VGA_R,VGA_G,VGA_B,ps2_clk,ps2_data);
	input clock, reset;

	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;

	//Added wires for reg outputs,inputs
	wire[31:0] reg_out_1,reg_in_1;

	//input        clk, 		// System Clock Input 100 Mhz
    input        micData;	// Microphone Output
    input[3:0]   switches;	// Tone control switches
    output      micClk; 	// Mic clock 
    output       chSel;		// Channel select; 0 for rising edge, 1 for falling edge
    output       audioOut;	// PWM signal to the audio jack	
    output       audioEn;   // Audio enable
    output [3:0] Anode_Activate; // anode signals of the 7-segment LED display
    output [6:0] LED_out;
	output hSync; 		// H Sync Signal
	output vSync; 		// Veritcal Sync Signal
	output[3:0] VGA_R;  // Red Signal Bits
	output[3:0] VGA_G;  // Green Signal Bits
	output[3:0] VGA_B;  // Blue Signal Bits
	inout ps2_clk;
	inout ps2_data;


	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "test_instr";
	
	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut)); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB), .reg_out_1(reg_out_1),.reg_in_1(reg_in_1));
						
	// Processor Memory (RAM)
	RAM1 ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));

	AudioController audioControl(
    .clk(clock), 		// System Clock Input 100 Mhz
    .micData(micData),	// Microphone Output
    .switches(switches),	// Tone control switches
    .micClk(micClk), 	// Mic clock 
    .chSel(chSel),		// Channel select; 0 for rising edge, 1 for falling edge
    .audioOut(audioOut),	// PWM signal to the audio jack	
    .audioEn(audioEn),   // Audio enable
    .Anode_Activate(Anode_Activate), // anode signals of the 7-segment LED display
    .LED_out(LED_out),
	.reset(reset),
	.hSync(hSync), 		// H Sync Signal
	.vSync(vSync), 		// Veritcal Sync Signal
	.VGA_R(VGA_R),  // Red Signal Bits
	.VGA_G(VGA_G),  // Green Signal Bits
	.VGA_B(VGA_B),  // Blue Signal Bits
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.score_val(reg_out_1),
	.counter_val(reg_in_1));

endmodule
