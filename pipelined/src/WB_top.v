//////////////////////////////////////////////
// Project      : WiscSP13 - Unpipelined    //
// Module       : WB_top                    //
// Descrption   : Writes back data to reg   //
// Author       : Hrishikesh Belatikar      //
// Date         : November 7th 2021         //
//////////////////////////////////////////////

module WB_top ( branch_PC, J_JAL_addr, EX_out, mem_data, PC2, mem_to_reg, J_JAL, JR_JALR, JAL_JALR, new_PC, write_back);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input CLK & RST
		//None

    //Input Signals
    input   wire    [15:0]  branch_PC,
                            J_JAL_addr,
                            EX_out,
                            mem_data,
                            PC2;

    //Input Control Signals
    input   wire            mem_to_reg,
                            J_JAL,
                            JR_JALR,
                            JAL_JALR;
    
    //Output Signals
    output  wire    [15:0]  new_PC,
                            write_back;
    
/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
	wire    [15:0]  branch_J,
                    mem_EX;

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
	//None

/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/
    assign mem_EX = mem_to_reg ? mem_data : EX_out;
    assign branch_J = J_JAL ? J_JAL_addr : branch_PC; 

    assign new_PC = JR_JALR ? EX_out : branch_J;	
    assign write_back = JAL_JALR ? PC2 : mem_EX;

endmodule
