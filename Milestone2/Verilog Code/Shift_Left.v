
module Shift_Left #(parameter N=8, parameter K=1)(input [N-1:0] num, output [N-1:0] shifted);
    assign shifted = {num[N-K-1:0], {K{1'b0}}};
endmodule
