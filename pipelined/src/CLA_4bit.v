
module CLA_4bit (A,B,Cin,S,Cout);
    input [3:0] A,B;
    input Cin;
    output [3:0] S;
    output Cout;

    wire [3:0] Gi, Pi;
    wire [4:1] C;

    sum_block iS0 [3:0] (.A(A), .B(B), .Cin({C[3:1],Cin}), .S(S), .Gi(Gi), .Pi(Pi));
    cla_block iC0 (.Gi(Gi), .Pi(Pi), .Cin(Cin), .C(C));

    assign Cout = C[4];

endmodule
