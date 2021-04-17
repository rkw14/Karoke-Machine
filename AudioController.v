module AudioController(
    input        clk, 		// System Clock Input 100 Mhz
    input        micData,	// Microphone Output
    input[3:0]   switches,	// Tone control switches
    output       micClk, 	// Mic clock 
    output       chSel,		// Channel select; 0 for rising edge, 1 for falling edge
    output       audioOut,	// PWM signal to the audio jack	
    output       audioEn);	// Audio Enable

	localparam MHz = 1000000;
	localparam SYSTEM_FREQ = 100*MHz; // System clock frequency

	assign chSel   = 1'b0;  // Collect Mic Data on the rising edge 
	assign audioEn = 1'b1;  // Enable Audio Output

	// Initialize the frequency array. FREQs[0] = 261
	reg[10:0] FREQs[0:15];
	initial begin
		$readmemh("FREQs.mem", FREQs);
	end
	
	////////////////////
	// Your Code Here //
	////////////////////
    
	wire [31:0] ctrFrequency = ((SYSTEM_FREQ / FREQs[switches]))>>1;
	wire [6:0] duty_cycle;
	wire [6:0] duty_cycle_mic;

	
	reg ourClock = 0;
	reg[31:0] counter = 0;
	always @(posedge clk) begin
	   if(counter < ctrFrequency - 1)
	       counter <= counter +1;
	   else begin
	       counter <=0;
	       ourClock <= ~ourClock;
	   end
    end
    
    assign duty_cycle = ourClock ? 7'd90 : 7'd10;
    
    
    reg stabilizedMicData;
    reg[31:0] counter2 = 0;
    always @(posedge clk) begin
        if (counter2 < 100)
            counter2 <= counter2 + 1;
        else begin
            counter2<=0;
            micClk <= ~micClk;
        end
    end
    always @(posedge micClk) begin
		stabilizedMicData <= micData
	end
    PWMDeserializer ourDeserializer(clk, 1'b0, stabilizedMicData, duty_cycle_mic);
    
    PWMSerializer ourSerializer(clk,1'b0, (duty_cycle + duty_cycle_mic)>>2, audioOut);


endmodule