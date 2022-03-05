//////////////////////////////////////////////
// Project      : WiscSP13 - Unpipelined    //
// Module       : mux_4_1_1bit             //
// Descrption   : It's a mux :D		        //
// Author       : Hrishikesh Belatikar      //
// Date         : November 5th 2021         //
//////////////////////////////////////////////

module mux_4_1_1bit (in0, in1, in2, in3, sel, out0);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input CLK & RST
		//None

    //Input Signals
    input wire  	in0,
                    in1,
                    in2,
                    in3;
    
    //Input Control Signals
    input wire [1:0]	sel;
    
    //Output Signals
    output wire   out0;

/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
	wire  	tempL,
            tempH;			

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
	//None

/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/
	assign tempL = sel[0] ? in1 : in0;
	assign tempH = sel[0] ? in3 : in2;
	assign out0  = sel[1] ? tempH : tempL;
	
endmodule
