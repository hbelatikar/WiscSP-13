module shifter (In, Cnt, Op, Out);
   
   input [15:0] In;
   input [3:0]  Cnt;
   input [1:0]  Op;
   output[15:0] Out;

   /*
   Your code goes here
   */
	
   wire [15:0] LogicalLShifter_Out, LogicalRShifter_Out, RRotator_Out, LRotator_Out;	//ArithRShifter_Out, 

   LRotator        LRo0 (.In(In) , .Out(LRotator_Out)        , .Cnt(Cnt));
   LogicalLShifter LL0  (.In(In) , .Out(LogicalLShifter_Out) , .Cnt(Cnt));
//   ArithRShifter   AR0  (.In(In) , .Out(ArithRShifter_Out)   , .Cnt(Cnt));
   RRotator        RRo0 (.In(In) , .Out(RRotator_Out)        , .Cnt(Cnt));
   LogicalRShifter LR0  (.In(In) , .Out(LogicalRShifter_Out) , .Cnt(Cnt));

   // mux4_1 M0[15:0] (.in0(ArithRShifter_Out), .in1(LogicalRShifter_Out), .in2(LRotator_Out), .in3(LogicalLShifter_Out), .sel(Op), .outY(Out));
   mux_4_1_16bit M0 (.in0(LRotator_Out), .in1(LogicalLShifter_Out), .in2(RRotator_Out), .in3(LogicalRShifter_Out), .sel(Op), .out0(Out));

endmodule

