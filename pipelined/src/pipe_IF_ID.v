//////////////////////////////////////////////
// Project      : WiscSP13 - Pipelined      //
// Module       : pipe_IF_ID                //
// Descrption   : IF/ID Pipeline Regs       //
// Author       : Hrishikesh Belatikar      //
// Date         : November 25th 2021        //
//////////////////////////////////////////////

module pipe_IF_ID (clk, rst, stall, flush, PC2, instr, ID_PC2, ID_instr);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input CLK & RST
		input   clk,
                rst;

    //Input Signals
        input  [15:0]   PC2,
                        instr;
        
        input           stall,
                        flush;

    //Input Control Signals

    //Output Signals
        output  [15:0]  ID_PC2,
                        ID_instr;
/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
	wire [15:0] stalled_PC2, stalled_instr;

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
	// Prog Counter + 2
    assign stalled_PC2 = (stall | flush) ? ID_PC2 : PC2;
    dff U0 [15:0] (.d(stalled_PC2), .q(ID_PC2), .clk(clk), .rst(rst));

    // Instruction
    /*
        if system reset or flush issued
            flop a NOP isntruction
        else 
            flop the fetched instruction
    */
    assign stalled_instr =  (rst|flush) ?   16'h0800    :
                            stall       ?   ID_instr    :
                            instr; 

    dff U1 [15:0] (.d(stalled_instr), .q(ID_instr), .clk(clk), .rst(1'b0));

/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/
	
endmodule
