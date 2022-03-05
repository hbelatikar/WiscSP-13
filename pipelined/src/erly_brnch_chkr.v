//////////////////////////////////////////////
// Project      : WiscSP13 - Pipelined      //
// Module       : erly_brnch_chkr           //
// Descrption   : Branch checker just       //
//              : after Register File       //
// Author       : Hrishikesh Belatikar      //
// Date         : November 30th 2021        //
//////////////////////////////////////////////

module erly_brnch_chkr (reg_to_check, branch_opcode, take_branch);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input CLK & RST
		//None

    //Input Signals
        input   [15:0]  reg_to_check;
        input   [4:0]   branch_opcode;

    //Input Control Signals
    
    //Output Signals
        output take_branch;
    
/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
	wire    early_zero,
            early_neg;

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
	//None

/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/
	assign early_zero   = (reg_to_check == 16'b0);
    assign early_neg    = (reg_to_check[15]);

    assign early_beqz   = early_zero & (branch_opcode == 5'b01100);
    assign early_bnez   = ~early_zero & (branch_opcode == 5'b01101);
    assign early_bltz   = early_neg & (branch_opcode == 5'b01110);
    assign early_bgez   = (early_zero|~early_neg) & (branch_opcode == 5'b01111);

    assign take_branch = early_beqz | early_bnez | early_bltz | early_bgez;

endmodule
