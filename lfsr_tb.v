module lfsr_tb;
reg clk;
reg rst;
reg [3:0] seed;
reg load;
wire q;
lfsr L(q, clk, rst,
seed, load);
integer i = 0;

// initial
// begin
// clk = 0;
// load = 0;
// seed = 0;
// rst = 0;
// // #25 rst = 1;
// rst = 0;
// end

// drive clock
always begin
    #25 clk = !clk;
end

// program lfsr
initial begin
clk = 0;
rst = 0;
seed = 4'b1111;
#10 load = 1;
#25 load = 0;
for (i = 0; i < 5; i = i + 1) begin
	@(negedge clk);
    $display("Random bit");
    $display(q);
    $display("Load");
    $display(load);
    $display("clk");
    $display(clk);
    $display("---------");
    // $display(q);

	end
// $display(q);
$finish;
end

endmodule
