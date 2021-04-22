module lfsr(q, clk, rst, seed, load);
output q;
input [3:0] seed;
input load;
input clk;
input rst;
wire [3:0] state_out;
wire [3:0] state_in;

flipflop_lfsr F[3:0] (state_out, clk, rst, state_in);

mux_lfsr M1[3:0] (state_in, load, seed, {state_out[2],state_out[1],state_out[0],nextbit});
xor G1(nextbit, state_out[2], state_out[3]);
assign q = nextbit;
// for (i = 0; i < 3; i = i + 1) begin
// 	//@(negedge clk);
//     //$display(q);
//     q[i] = nextbit;

// 	end
endmodule