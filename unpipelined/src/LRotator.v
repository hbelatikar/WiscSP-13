
module LRotator (In, Cnt, Out);
	input [15:0] In;
	input [3:0]  Cnt;
	output [15:0] Out;
	
	wire [15:0] MR_out_0, MR_out_1, MR_out_2;
	
	// mux_row_16 MR0 (.In1({  In[14:0]      , In[15]          }), .In0(In),       .Sel(Cnt[0]), .Out(MR_out_0));
	// mux_row_16 MR1 (.In1({ MR_out_0[13:0] , MR_out_0[15:14] }), .In0(MR_out_0), .Sel(Cnt[1]), .Out(MR_out_1));
	// mux_row_16 MR2 (.In1({ MR_out_1[11:0] , MR_out_1[15:12] }), .In0(MR_out_1), .Sel(Cnt[2]), .Out(MR_out_2));
	// mux_row_16 MR3 (.In1({ MR_out_2[7:0]  , MR_out_2[15:8]  }), .In0(MR_out_2), .Sel(Cnt[3]), .Out(Out));
	
	assign MR_out_0 = Cnt[0] ? {  In[14:0]      , In[15]          } : In;
	assign MR_out_1 = Cnt[1] ? { MR_out_0[13:0] , MR_out_0[15:14] } : MR_out_0;
	assign MR_out_2 = Cnt[2] ? { MR_out_1[11:0] , MR_out_1[15:12] } : MR_out_1;
	assign Out      = Cnt[3] ? { MR_out_2[7:0]  , MR_out_2[15:8]  } : MR_out_2;
	
endmodule