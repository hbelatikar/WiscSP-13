module fulladder1 (A,B,Cin,S,Cout);
    input A,B,Cin;
    output S,Cout;

    assign S    = A ^ B ^ Cin;

    assign Cout = Cin & (A^B) | (A&B);

endmodule