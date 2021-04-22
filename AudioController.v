module AudioController(
    input        clk, 		// System Clock Input 100 Mhz
    input        micData,	// Microphone Output
    input[3:0]   switches,	// Tone control switches
    output reg      micClk, 	// Mic clock 
    output       chSel,		// Channel select; 0 for rising edge, 1 for falling edge
    output       audioOut,	// PWM signal to the audio jack	
    output       audioEn,   // Audio enable
    output [3:0] Anode_Activate, // anode signals of the 7-segment LED display
    output [6:0] LED_out,
	output LEDout,
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	inout ps2_clk,
	inout ps2_data,
	input reset,
	input[31:0] score_val,
	output[31:0] counter_val);	

	localparam MHz = 1000000;
	localparam SYSTEM_FREQ = 100*MHz; // System clock frequency

	assign chSel   = 1'b0;  // Collect Mic Data on the rising edge 
	assign audioEn = 1'b1;  // Enable Audio Output

	// Initialize the frequency array. FREQs[0] = 261
	reg[10:0] FREQs[0:15];
	initial begin
		$readmemh("FREQs.mem", FREQs);
	end
	reg[10:0] target[0:15];
	initial begin
		$readmemh("TARGET.mem",target);
	end
	reg [3:0] displayPosition;
	reg [3:0] counter_pos= 0;
	reg [15:0] score=0;
	reg [31:0] correct_count = 0;
	always @(*)
	begin
		case(target[counter_pos])
		11'h105: displayPosition = 4'd0;
		11'h125: displayPosition = 4'd1;
		11'h149: displayPosition = 4'd2;
		11'h15d: displayPosition = 4'd3;
		11'h187: displayPosition = 4'd4;
		11'h1b8: displayPosition = 4'd5;
		11'h1ed: displayPosition = 4'd6;
		11'h20b: displayPosition = 4'd7;
		11'h24b: displayPosition = 4'd8;
		11'h293: displayPosition = 4'd9;
		11'h2ba: displayPosition = 4'd10;
		11'h30f: displayPosition = 4'd11;
		11'h370: displayPosition = 4'd12;
		11'h3db: displayPosition = 4'd13;
		11'h416: displayPosition = 4'd14;
		11'h496: displayPosition = 4'd15;
		default: displayPosition = 4'd0;
		endcase
	end

	// always @(posedge clk)begin

	// 	score <= score_val;
	// 	if (displayPosition == switches) begin
	// 		//score<= score + 5;
	// 		correct_count <= correct_count + 1;
	// 		if (counter_pos == 8) begin
	// 			counter_pos <= 0;
	// 		end
	// 		else begin
	// 			counter_pos<= counter_pos + 1;
	// 		end
	// 	end

	// end

	reg load = 1;
	reg[3:0] temp_reg = 0;

	always @(negedge clk)begin
		load <= 1'b0;
	end

	wire q;
	lfsr randomizer(q, clk, 1'b0, 4'd5, load);

	always @(posedge clk)begin

		score <= score_val;
		if (displayPosition == switches) begin
			
			correct_count <= correct_count + 1;

			counter_pos[2:0] <= temp_reg[3:1];
			counter_pos[3] <= q;
			temp_reg <= counter_pos;

			
		end

	end

	assign counter_val = correct_count;	
	////////////////////
	// Your Code Here //
	////////////////////

	wire [31:0] ctrFrequency = ((SYSTEM_FREQ / FREQs[switches]))>>1;
	wire [6:0] duty_cycle;
	wire [6:0] duty_cycle_mic;


	// reg micClk = 0;
	initial begin
		micClk <= 0;
	end
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
    
    assign duty_cycle = ourClock ? 7'd70 : 7'd30;
    
    
    reg stabilizedMicData;
    reg[31:0] counter2 = 0;
    always @(posedge clk) begin
        if (counter2 < 50)
            counter2 <= counter2 + 1;
        else begin
            counter2<=0;
            micClk <= ~micClk;
        end
    end
    
	always @(posedge micClk) begin
		stabilizedMicData <= micData;
	end

	reg [26:0] one_second_counter;
	reg toggle;

	always @(posedge micClk) begin
		if(one_second_counter>=99999999) begin
            one_second_counter <= 0;
			toggle <= ~toggle;
			end
        else 
            one_second_counter <= one_second_counter + 1;
	end




    wire [15:0] micFrequency;
    //PWMDeserializer ourDeserializer(clk, 1'b0, stabilizedMicData, duty_cycle_mic);
    
    PWMSerializer ourSerializer(clk,1'b0, duty_cycle, audioOut);
	wire [15:0] signal;
	assign signal = score;
	//assign  signal [15:4] = 12'b0;
	//assign  signal  [3:0] = switches;
	Seven_Segment_Display_Number dis(clk, reset, signal, Anode_Activate, LED_out );

	VGAController vga(clk, reset, hSync, vSync, VGA_R, VGA_G, VGA_B,
	ps2_clk, ps2_data, LEDout, displayPosition );
	//MicFreq mic(clk, reset, stabilizedMicData, micFrequency);

endmodule