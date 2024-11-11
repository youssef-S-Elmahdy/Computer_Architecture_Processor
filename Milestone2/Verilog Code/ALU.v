

module ALU #(parameter n = 32)(input [n-1:0] A, input [n-1:0] B, input [3:0] Sel, output Zflag, output Cflag, output Vflag, output Sflag, output reg [n-1:0] ALU_out);
    wire [n-1:0] ADD;
    wire [n-1:0] SUB;
    wire [n-1:0] mux_out;
    
    mux_2x1 #(.n(32)) mux(.A(~B+1), .B(B), .S(Sel[2]),.C(mux_out));
    RCA #(.n(32)) rca (.A(A), .B(mux_out), .Sum(ADD), .Carry(Cflag), .Overflow(Vflag));
    
    assign SUB = ADD;
    
    always @ (*) begin
         case(Sel)
            4'b0000: ALU_out = A & B;
            4'b0001: ALU_out =  A | B;
            4'b0010: ALU_out = ADD;
            4'b0011: ALU_out = A ^ B;
            4'b0100: ALU_out = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
            4'b0101: ALU_out = (A < B) ? 32'd1 : 32'd0;
            4'b0110: ALU_out = SUB;
            4'b0111: ALU_out = A >> B;
            4'b1000: ALU_out = $signed(A) >>> B;
            4'b1001: ALU_out = A << B;
            default: ALU_out = 32'd0;
         endcase
    end
    
    assign Zflag = (ALU_out == 0) ? 1'b1 : 1'b0;
    assign Sflag = (ALU_out[31] == 0) ? 1'b0 : 1'b1;
        
endmodule