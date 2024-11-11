
module DataPath(input clk, input rst, output O);
    wire VflagD; //Dummy wire
    wire CflagD; //Dummy wire
    wire [31:0]PC_in;
    wire [31:0]PC_out;
    Register_n_bit #(.n(32)) PC (.D(PC_in), .rst(rst), .Load(1'b1), .clk(clk), .Q(PC_out));
    
    wire [31:0]Inst;
    InstMem IM(.addr(PC_out[7:2]), .data_out(Inst));
    
    wire [31:0] WD; 
    
    wire branch;
    wire jalr;
    wire MemRead;
    wire [1:0]WRFSel; //Mem to Reg
    wire jump; // jump signal
    wire [1:0]ALUOp; //2 to 4 bits change
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;
       
    
    Control_Unit CU(.opcode(Inst[6:2]), .branch(branch), .jump(jump), .jalr(jalr), .MemRead(MemRead),.WRFSel(WRFSel),.MemWrite(MemWrite),.ALUSrc(ALUSrc),.RegWrite(RegWrite), .ALUOp(ALUOp));
    
    wire [31:0]RD1;
    wire [31:0]RD2;
    
    RegFile #(.n(32)) RF (.RS1(Inst[19:15]), .RS2(Inst[24:20]), .RD(Inst[11:7]), .regWrite(RegWrite), .clk(clk), .rst(rst), .writeData(WD), .readData1(RD1), .readData2(RD2));
    
    wire [31:0]Imm;
    ImmGen IMG(.Gen_Out(Imm), .Inst(Inst));
    
    wire [31:0] shiftedImm12;
    Shift_Left #(.N(32), .K(12)) SL12(.num(Imm), .shifted(shiftedImm12));
    
    wire [31:0] ALU_In2;
    mux_2x1 #(.n(32)) mux_ALUIn (.A(Imm), .B(RD2), .S(ALUSrc), .C(ALU_In2));
    
    wire [3:0] ALUSel;
    ALU_Control_Unit ALU_CU (.funct3(Inst[14:12]), .funct7(Inst[30]), .ALUop(ALUOp), .ALUSel(ALUSel));
    
    wire [31:0] ALURes;
    wire Zflag;
    wire Cflag;
    wire Vflag;
    wire Sflag;
    
    ALU #(.n(32)) ALU(.A(RD1), .B(ALU_In2), .Sel(ALUSel), .Zflag(Zflag), .Cflag(Cflag), .Vflag(Vflag), .Sflag(Sflag), .ALU_out(ALURes));
     
    wire [31:0] DataMemRes;
    DataMem DM (.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .addr(ALURes[7:2]), .data_in(RD2), .data_out(DataMemRes));
    
    wire [31:0] Auipc_Res;
    RCA #(.n(32)) Adder_Auipc (.A(PC_out), .B(shiftedImm12), .Sum(Auipc_Res), .Carry(CflagD), .Overflow(VflagD));
    
    wire [31:0] MuxUformat_Res;
    mux_2x1 #(.n(32)) mux_Uformat (.A(shiftedImm12), .B(Auipc_Res), .S(Inst[5]), .C(MuxUformat_Res));
    
    mux_4x1 #(.n(32)) mux_WRF (.A(DataMemRes), .B(PC_add4), .C(ALURes), .D(MuxUformat_Res), .S(WRFSel), .R(WD));
     
    wire [31:0] PC_add4;
    RCA #(.n(32)) Adder_4 (.A(PC_out), .B(32'd4), .Sum(PC_add4), .Carry(CflagD), .Overflow(VflagD));
     
    wire [31:0] shiftedImm1;
    Shift_Left #(.N(32), .K(1)) SL1(.num(Imm), .shifted(shiftedImm1));
     
    wire [31:0] PC_Branch;
    RCA #(.n(32)) Adder_Branch (.A(PC_out), .B(shiftedImm1), .Sum(PC_Branch), .Carry(CflagD), .Overflow(VflagD));
    
    wire Branch_Bit;
    Branch_Unit BU (.Zflag(Zflag), .Cflag(Cflag), .Vflag(Vflag), .Sflag(Sflag), .Branch(branch), .funct3(Inst[14:12]), .Branch_Bit(Branch_Bit));
    
    wire [1:0] PCSel;
    assign PCSel = {(Branch_Bit | jump), jalr};
    
    mux_4x1 #(.n(32)) mux_PC (.A(PC_add4), .B(ALURes), .C(PC_Branch), .D(32'd0), .S(PCSel), .R(PC_in));
   
       
endmodule
