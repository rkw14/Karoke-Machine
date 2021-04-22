module lfsr_tb;
reg clk;
reg rst;
reg [3:0] seed;
reg load;
wire q;
lfsr L(q, clk, rst,
seed, load);
integer i = 0;

initial
begin
clk = 0;
load = 0;
seed = 0;
rst = 0;
#10 rst = 1;
#10 rst = 0;
end

// drive clock
always begin
    #25 clk = !clk;
end

// program lfsr
initial begin
seed = 4'b0011;
load = 1;
#75 load = 0;
for (i = 0; i < 10; i = i + 1) begin
	@(negedge clk);
    $display(q);

	end
// $display(q);
$finish;
end

endmodule
