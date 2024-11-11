
module Stalling_Unit(input [4:0] RS1_ID, input [4:0] RS2_ID, input [4:0] RD_EX, input MemRead_EX,output reg Stall);
    always @(*) begin
        if (((RS1_ID==RD_EX) || (RS2_ID==RD_EX)) && MemRead_EX && (RD_EX != 5'b0))
            Stall = 1'b1;
        else 
            Stall = 1'b0;
    end
endmodule