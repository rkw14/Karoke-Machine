module flipflop_lfsr(q, clk, rst, d);
input clk;
input rst;
input d;
output q;
reg q;
always @(posedge clk or posedge rst) begin
if (rst)
q = 0;
else
q = d;
end
endmodule