//////////////////////////////////////////////
// Project      : WiscSP13 - Unpipelined    //
// Module       : IF_top                    //
// Descrption   : Fetches next instruction  //
// Author       : Hrishikesh Belatikar      //
// Date         : November 5th 2021         //
//////////////////////////////////////////////

module IF_top (clk, rst, new_PC, PC2, instr, halt, exception);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input CLK & RST
    input wire  clk,
                rst;

    //Input Signals
    input wire [15:0] new_PC;
    
    //Input Control Signals
    input wire  halt,
                exception;  //Keep constantly low for unpipelined project
    
    //Output Signals
    output wire [15:0]  PC2,
                        instr;

/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
    wire [15:0] PC_exception,
                PC_halt,
                PC;
    wire PC2_overflow_err;

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
    memory2c    iIMEM  (.data_out(instr), .data_in(16'b0), .addr(PC), 
                        .enable(1'b1), .wr(1'b0), .createdump(1'b0), 
                        .clk(clk), .rst(rst));
    
    progCounter iPC    (.nxt_addr(PC_halt), .curr_addr(PC), 
                        .clk(clk), .rst(rst)); 

/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/
    assign PC_exception = exception ? 16'h0002 : new_PC;

    assign PC_halt = halt ? PC : PC_exception;

    assign {PC2_overflow_err, PC2} = PC + 16'h0002;

endmodule