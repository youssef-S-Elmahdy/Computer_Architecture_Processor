

module ImmGen (output reg [31:0] Gen_Out, input [31:0] Inst);
    wire [6:0] Opcode;
    assign Opcode = Inst[6:0];
    wire [2:0] funct3; 
    assign funct3 = Inst[14:12];

    always @(*) begin
        case (Opcode)
            7'b0000011: Gen_Out = {{20{Inst[31]}}, Inst[31:20]}; // Load
            7'b0010011: Gen_Out = (funct3 == 3'b101) ? {27'b0, Inst[24:20]} : {{20{Inst[31]}}, Inst[31:20]}; // I-Type Arithmetic
            7'b1100111: Gen_Out = {{20{Inst[31]}}, Inst[31:20]}; // JALR
             
            7'b0100011: Gen_Out = {{20{Inst[31]}}, Inst[31:25], Inst[11:7]}; //Store

            7'b1100011: Gen_Out = {{19{Inst[31]}}, Inst[31], Inst[7], Inst[30:25], Inst[11:8], 1'b0}; //Branch

            7'b0110111: Gen_Out = {Inst[31:12], 12'b0}; // LUI
            7'b0010111: Gen_Out = {Inst[31:12], 12'b0}; // AUIPC
           
            7'b1101111: Gen_Out = {{11{Inst[31]}}, Inst[31], Inst[19:12], Inst[20], Inst[30:21], 1'b0}; //JAL
                
            default:
                Gen_Out = 32'd0;
        endcase
    end
endmodule