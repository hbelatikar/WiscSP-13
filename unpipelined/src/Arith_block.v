
module Arith_block ( A, B, Cin, sign, Out, Ofl, op);

    input [15:0] A, B;
    input Cin, sign;
    input [1:0] op;

    output [15:0] Out;
    output Ofl;
    
    wire [15:0] Out_S, Out_Or, Out_And, Out_Xor;
    wire CLA_ofl;

    //CLA
    CLA_16bit CLA0(.A(A), .B(B), .Cin(Cin), .S(Out_S), .Cout(CLA_ofl));
    
    //OR
    // Or_block  OR0 (.A(A), .B(B),  .Y(Out_Or));
    assign Out_Or = A | B;
    
    //AND
    // And_block AND0(.A(A), .B(B),  .Y(Out_And));
    assign Out_And = A & B;
    
    //XOR
    // Xor_block XOR0(.A(A), .B(B),  .Y(Out_Xor));
    assign Out_Xor = A ^ B;
    
    //Overflow Detector
    // Overflow_block OB0 (.sign(sign), .ofl(Ofl), .CLAOfl(CLA_ofl), .A_msb(A[15]), .B_msb(B[15]), .S_msb(Out_S[15]));
    wire AxB, SxA, unsig_ofl;
    assign AxB = A[15]^B[15];
    assign SxA = Out_S[15]^A[15];
    assign Ofl = sign ? unsig_ofl : CLA_ofl;
    assign unsig_ofl = AxB ? 1'b0 : SxA;
    //assign Ofl = sign ? (A[15]^B[15]) ? 1'b0 : (Out_S[15]^A[15]) : CLA_ofl;

    // mux4_1 M0[15:0] (.in0(Out_S), .in1(Out_Or), .in2(Out_Xor), .in3(Out_And), .sel(op), .outY(Out));
    mux_4_1_16bit M0 (.in0(Out_S), .in1(Out_Or), .in2(Out_Xor), .in3(Out_And), .sel(op), .out0(Out));

endmodule
