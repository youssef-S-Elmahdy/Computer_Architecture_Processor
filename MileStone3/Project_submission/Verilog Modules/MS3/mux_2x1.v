

module mux_2x1 #(parameter n=32) (input [n-1:0] A,input [n-1:0] B,input  S,output [n-1:0] C);
    genvar i;
    generate
    for (i=0;i<n; i=i+1) begin
        assign C[i] = S ? A[i] : B[i];
    end
    endgenerate
endmodule
