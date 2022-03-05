
module LogicalRShifter (In, Cnt, Out);
	input [15:0] In;
	input [3:0]  Cnt;
	output [15:0] Out;
	
	wire [15:0] MR_out_0, MR_out_1, MR_out_2;
	
	// mux_row_16 MR0 (.In1({ 1'b0      , In[15:1]       }), .In0(In), 	  .Sel(Cnt[0]), .Out(MR_out_0));
	// mux_row_16 MR1 (.In1({ {2{1'b0}} , MR_out_0[15:2] }), .In0(MR_out_0), .Sel(Cnt[1]), .Out(MR_out_1));
	// mux_row_16 MR2 (.In1({ {4{1'b0}} , MR_out_1[15:4] }), .In0(MR_out_1), .Sel(Cnt[2]), .Out(MR_out_2));
	// mux_row_16 MR3 (.In1({ {8{1'b0}} , MR_out_2[15:8] }), .In0(MR_out_2), .Sel(Cnt[3]), .Out(Out));

	assign MR_out_0 = Cnt[0] ? { 1'b0      , In[15:1]       } : In;
	assign MR_out_1 = Cnt[1] ? { {2{1'b0}} , MR_out_0[15:2] } : MR_out_0;
	assign MR_out_2 = Cnt[2] ? { {4{1'b0}} , MR_out_1[15:4] } : MR_out_1;
	assign Out      = Cnt[3] ? { {8{1'b0}} , MR_out_2[15:8] } : MR_out_2;

	
endmodule