`timescale 1ns / 1ps
module MicFreq #(
    parameter
    WAVE_FREQ  = 10,
    PULSE_FREQ = 1000,
    SYS_FREQ   = 100000) (
    input clk,
    input reset,
    input signal,
    output reg[15:0] micFrequency);
    
    localparam WAVE_WINDOW        = 500000;
    localparam SMALL_WAVE_WINDOW  = WAVE_WINDOW/100;
    localparam WAVE_HALF          = WAVE_WINDOW >> 1;
    localparam WAVE_COUNTER_BITS  = $clog2(WAVE_WINDOW) + 1;
    reg bool_wire = 1;
    
    reg[WAVE_COUNTER_BITS-1:0] pulseCounter = 0;
    reg[WAVE_COUNTER_BITS-1:0] sigOn = 0;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            pulseCounter <= 0;
        
        end else begin
            if(pulseCounter < WAVE_WINDOW-1) begin
                pulseCounter <= pulseCounter + 1;
                bool_wire <= 1;
            end else begin
                pulseCounter <= 0;
                bool_wire <= 0;
            end
        end
    end
    


    always @(posedge signal)begin
        sigOn <= bool_wire ? sigOn + 1 : 1;
    end


    always @(negedge clk) begin
        if(pulseCounter == WAVE_WINDOW-1)
            micFrequency <= sigOn * 200;
    end

    
endmodule