//////////////////////////////////////////////////
// Project      : WiscSP13 - Unpipelined        //
// Module       : set_checker                   //
// Descrption   : Set/Reset output as per instr //
// Author       : Hrishikesh Belatikar          //
// Date         : November 5th 2021             //
//////////////////////////////////////////////////

module set_checker (zero, neg, ofl, set_typ, set_out);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input CLK & RST
		//None

    //Input Signals
    input   wire            zero,
                            neg,
                            ofl;

    //Input Control Signals
    input   wire    [1:0]   set_typ;

    //Output Signals
    output  wire    [15:0]  set_out;
    
/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
	wire    neg_or_zero,
          set_trimmed;

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
	mux_4_1_1bit M0 (.in0(zero), .in1(neg),. in2(neg_or_zero), .in3(ofl), .sel(set_typ), .out0(set_trimmed));

/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/
	assign neg_or_zero = neg | zero;
  assign set_out = { {15{1'b0}} , set_trimmed };

endmodule
