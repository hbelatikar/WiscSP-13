
module cla_block ( Pi, Gi, Cin, C);
    input [3:0] Pi;
    input [3:0] Gi;
    input Cin;

    output [4:1] C;

    wire [3:0] PaC;

    //Generating carry C1  :: C1 = G0 + P0Cin
    and AD0 (PaC[0], Pi[0], Cin);
    or  OR0 (C[1], Gi[0], PaC[0]);

    //Generating carry C2  :: C2 = G1 + P1C1
    and AD1  (PaC[1], Pi[1], C[1]);
    or  OR1 (C[2], Gi[1], PaC[1]);
    
    //Generating carry C3  :: C3 = G2 + P2C2
    and AD2 (PaC[2], Pi[2], C[2]);
    or  OR2 (C[3], Gi[2], PaC[2]);

    //Generating carry C4   :: C4 = G3 + P3C3
    and AD3 (PaC[3], Pi[3], C[3]);
    or  OR3 (C[4], Gi[3], PaC[3]);

endmodule
