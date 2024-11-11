
module DataPath_tb;
  localparam clock_period = 10;
   reg clk;
   reg rst;
   wire [15:0] O;
   
   DataPath DP (.clk(clk), .rst(rst), .Inst_exec(O));
   initial begin 
       clk = 0;
       forever #(clock_period/2) clk = ~clk;
   end
    
   initial begin
       rst = 1;
       #(clock_period/2) 
        
       rst = 0;
    end
                 
endmodule