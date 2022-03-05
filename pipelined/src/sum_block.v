module sum_block (A, B, Cin, S, Pi, Gi);
    input A,B,Cin;
    output Pi, Gi, S;

    xor X0 (Pi, A , B);    //Calculate the Propogate Pi
    xor X1 (S, Pi, Cin);   //Output the sum S

    and A0 (Gi, A, B);     //Calculate the Generate 'Gi'

endmodule
