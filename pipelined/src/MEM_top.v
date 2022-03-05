//////////////////////////////////////////////
// Project      : WiscSP13 - Unpipelined    //
// Module       : MEM_top                   //
// Descrption   : Data memory interface     //
// Author       : Hrishikesh Belatikar      //
// Date         : November 7th 2021         //
//////////////////////////////////////////////

module MEM_top (clk, rst, PC2, imm_16bit, branch_sel, EX_out, read_reg_2, branch, mem_write, mem_read, branch_PC, mem_data);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input CLK & RST
    input   wire            clk,
                            rst;

    //Input Signals
    input   wire    [15:0]  EX_out,
                            read_reg_2,
                            PC2,
                            imm_16bit;
                            
    input   wire            branch_sel;

    //Input Control Signals
    input   wire            branch,
                            mem_write,
                            mem_read;
    
    //Output Signals
    output  wire    [15:0]  branch_PC,
                            mem_data;
    
/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
	wire    [15:0]  calc_PC,
                    fwd_mem_data,
                    mem_data_to_store;
    wire            branched_en,
        			err_branch_ofl,
                    MEM_needs_fwd;

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
    memory2c    iDMEM  (.data_out(mem_data), .data_in(read_reg_2), .addr(EX_out),
                        .enable(mem_write|mem_read), .wr(mem_write), .createdump(1'b0), 
                        .clk(clk), .rst(rst));
    CLA_16bit   CLA0   (.A(PC2), .B(imm_16bit), .Cin(1'b0), .S(calc_PC), .Cout(err_branch_ofl));
    
/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/
    assign branched_en = branch & branch_sel;

    assign branch_PC = branched_en ? calc_PC : PC2;
    
    assign mem_data_to_store = MEM_needs_fwd ? fwd_mem_data : read_reg_2;
//  assign {err_branch_ofl,calc_PC} = PC2 + imm_16bit;

endmodule
