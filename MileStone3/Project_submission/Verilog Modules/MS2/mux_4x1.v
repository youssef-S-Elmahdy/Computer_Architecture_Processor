module mux_4x1 #(parameter n=32) (input [n-1:0] A,input [n-1:0] B, input [n-1:0] C,input [n-1:0] D,input [1:0] S,output reg [n-1:0] R);
    always @ (*) 
    begin
        case(S)
            2'b00: R = A;
            2'b01: R = B;
            2'b10: R = C;
            2'b11: R = D;
            default: R = A;
        endcase
    end 
endmodule