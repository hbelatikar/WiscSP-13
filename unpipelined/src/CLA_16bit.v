
module CLA_16bit ( A, B, Cin, S, Cout);
  
    input  [15:0] A, B;
    input  Cin;
    output [15:0] S;
    output Cout;

    wire [2:0] C_ripple;

    CLA_4bit CLA4_0 (.A(A[3:0])  , .B(B[3:0])  , .Cin(Cin)        , .S(S[3:0])  , .Cout(C_ripple[0]));
    CLA_4bit CLA4_1 (.A(A[7:4])  , .B(B[7:4])  , .Cin(C_ripple[0]), .S(S[7:4])  , .Cout(C_ripple[1]));
    CLA_4bit CLA4_2 (.A(A[11:8]) , .B(B[11:8]) , .Cin(C_ripple[1]), .S(S[11:8]) , .Cout(C_ripple[2]));
    CLA_4bit CLA4_3 (.A(A[15:12]), .B(B[15:12]), .Cin(C_ripple[2]), .S(S[15:12]), .Cout(Cout));

endmodule