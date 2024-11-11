
module Forwarding_Unit(input EX_MEM_RegWrite, input [4:0] EX_MEM_RD, input [4:0] ID_EX_RS1, input [4:0] ID_EX_RS2, input MEM_WB_RegWrite, input [4:0] MEM_WB_RD , output reg [1:0] forwardA, output reg [1:0] forwardB);
    always @(*) begin
        if(EX_MEM_RegWrite && (EX_MEM_RD != 5'd0) && (EX_MEM_RD == ID_EX_RS1))
            forwardA = 2'b10;
        else if(MEM_WB_RegWrite && (MEM_WB_RD != 5'd0) && (MEM_WB_RD == ID_EX_RS1))
            forwardA = 2'b01;
        else
            forwardA = 2'b00;
                    
        if(EX_MEM_RegWrite && (EX_MEM_RD != 5'd0) && (EX_MEM_RD == ID_EX_RS2))
            forwardB = 2'b10;
        else if(MEM_WB_RegWrite && (MEM_WB_RD != 5'd0) && (MEM_WB_RD == ID_EX_RS2))
            forwardB = 2'b01;
        else
            forwardB = 2'b00;
    end
endmodule