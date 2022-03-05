//////////////////////////////////////////////
// Project      : WiscSP13 - Unpipelined    //
// Module       : IF_top                    //
// Descrption   : Fetches next instruction  //
// Author       : Hrishikesh Belatikar      //
// Date         : November 5th 2021         //
//////////////////////////////////////////////

module IF_top (clk, rst, stall, new_PC, PC2, instr, halt, exception, RTI, branch_or_jump, EPC);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input CLK & RST
    input wire  clk,
                rst;

    //Input Signals
    input wire stall;

    input wire [15:0] new_PC, EPC;
    
    //Input Control Signals
    input wire  halt,
                RTI,
                exception,
                branch_or_jump;  
    
    //Output Signals
    output wire [15:0]  PC2,
                        instr;

/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
    wire [15:0]    nxt_PC, PC;
    
    wire PC2_overflow_err;

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
    memory2c    iIMEM  (.data_out(instr), .data_in(16'b0), .addr(PC), 
                        .enable(1'b1), .wr(1'b0), .createdump(1'b0), 
                        .clk(clk), .rst(rst));
    
    progCounter iPC    (.nxt_addr(nxt_PC), .curr_addr(PC), 
                         .clk(clk), .rst(rst)); 
                        
    CLA_16bit   CLA0   (.A(PC), .B(16'h0002), .Cin(1'b0), .S(PC2), .Cout(PC2_overflow_err));

/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/

    // PseudoCode:-
    // if(halt | stall)
    //     nxt_PC = PC;
    // else if (exception)
    //     nxt_PC = 16'h002;
    // else if (branch)
    //     nxt_PC = new_PC;
    
    assign nxt_PC = exception       ?   16'h0002    :
                    RTI             ?   EPC         :
                    branch_or_jump  ?   new_PC      :
                    (halt | stall)  ?   PC          :
                    PC2;

endmodule