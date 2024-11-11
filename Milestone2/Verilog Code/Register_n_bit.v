
module Register_n_bit #(parameter n = 4)(input [n-1:0] D, input rst, input Load, input clk, output [n-1:0] Q);
    wire [n-1:0] mux_out; 
    genvar i;
    generate 
        for(i=0; i<n; i=i+1) begin 
           mux_2x1 #(.n(1)) mux(.A(D[i]), .B(Q[i]), .S(Load), .C(mux_out[i]));
           DFlipFlop dff(.clk(clk), .rst(rst), .D(mux_out[i]), .Q(Q[i]));
        end 
    endgenerate
endmodule
