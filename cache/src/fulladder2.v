module fulladder2 (A,B,Cin,S,Cout);
	input [1:0] A,B;
	input Cin;
	output [1:0] S;
	output Cout;
	
	wire C_rip;
	
	fulladder1 FA0 (.A(A[0]), .B(B[0]), .Cin(Cin)  , .S(S[0]), .Cout(C_rip));
	fulladder1 FA1 (.A(A[1]), .B(B[1]), .Cin(C_rip), .S(S[1]), .Cout(Cout));


endmodule