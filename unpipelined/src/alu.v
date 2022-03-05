
module alu (A, B, Cin, Op, invA, invB, sign, Out, Ofl, neg, Z);
   
   input  [15:0]  A;
   input  [15:0]  B;
   input          Cin;
   input  [2:0]   Op;

   input          invA;
   input          invB;
   input          sign;

   output         Ofl;
   output         neg;
   output         Z;
   output [15:0]  Out;

   /*
	Your code goes here
   */
   wire  [15:0]   In_A, In_B, Arith_Out, Shifter_Out; 

   //Inversion Block
   // Inversion_block INV0 (.A(A), .B(B), .InvA(invA), .InvB(invB), .OutA(In_A), .OutB(In_B));
   assign In_A = invA ? ~A : A;
   assign In_B = invB ? ~B : B;

   //Arithmetic block
   Arith_block ARTH0 (.A(In_A), .B(In_B), .Cin(Cin), .Out(Arith_Out), .Ofl(Ofl), .op(Op[1:0]), .sign(sign));
   
   //Shifter block
   shifter SHF0 (.In(In_A), .Cnt(In_B[3:0]), .Op(Op[1:0]), .Out(Shifter_Out));

   //Mux blocks to select output : sel = op[2]
   // mux_row_16 MR0 (.In0(Arith_Out), .In1(Shifter_Out), .Sel(Op[2]), .Out(Out));
   assign Out = Op[2] ? Shifter_Out : Arith_Out;

   //Assign the zero flag
   // zero_check ZC0 (.data(Out), .z_flag(Z));
   assign Z = ~(|Out);

   //assign neg = Out[15] & sign;
   assign neg = (~B[15] & Out[15]) | (A[15] & ~B[15]) | (A[15] & Out[15]);
//    ~B_msb & S_msb | A_msb & ~B_msb | A_msb & S_msb

endmodule
