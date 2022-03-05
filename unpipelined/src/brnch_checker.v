//////////////////////////////////////////////
// Project      : WiscSP13 - Unpipelined    //
// Module       : brnch_checker             //
// Descrption   : Sets bit if branch needed //
// Author       : Hrishikesh Belatikar      //
// Date         : November 5th 2021         //
//////////////////////////////////////////////

module brnch_checker (zero, neg, branch_typ, branch_sel);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input CLK & RST
		//None

    //Input Signals
        input   wire        zero,
                            neg;

    //Input Control Signals
        input   wire [1:0]  branch_typ;

    //Output Signals
        output  wire        branch_sel;
/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
	wire gteqz;

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
	mux_4_1_1bit M0 (.in0(zero), .in1(~zero),. in2(neg), .in3(gteqz), .sel(branch_typ), .out0(branch_sel));

/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/
	assign gteqz = zero | ~neg;
    
endmodule
