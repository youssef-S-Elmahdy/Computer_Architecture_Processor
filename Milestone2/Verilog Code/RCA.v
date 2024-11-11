

module RCA #(parameter n=8)(input [n-1:0] A, input [n-1:0] B,output [n-1:0] Sum, output Carry, output Overflow);
    wire [n:0] C;
    assign C[0] = 1'b0;
    genvar i;
    
    generate 
        for(i =0; i<n; i=i+1) begin
            full_adder FA(.A(A[i]), .B(B[i]), .cin(C[i]), .P(Sum[i]), .cout(C[i+1]));
        end
    endgenerate 
    
    assign Carry = C[n];
    assign Overflow = C[n] ^ C[n-1];
    
endmodule
