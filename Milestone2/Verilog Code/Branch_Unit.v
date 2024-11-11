module Branch_Unit(input Zflag, input Cflag, input Vflag, input Sflag, input Branch, input [2:0] funct3, output reg Branch_Bit);
    always @ (*) 
    begin
        case(funct3)
           3'b000: Branch_Bit = Zflag & Branch;
           3'b001: Branch_Bit = ~Zflag & Branch;
           3'b100: Branch_Bit = (Sflag != Vflag) & Branch;
           3'b101: Branch_Bit = (Sflag == Vflag) & Branch;
           3'b110: Branch_Bit = ~Cflag & Branch;
           3'b111: Branch_Bit = Cflag & Branch;
           default: Branch_Bit = 1'b0;
         endcase
    
    end
endmodule
