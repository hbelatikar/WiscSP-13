//////////////////////////////////////////////
// Project      : WiscSP13 - Pipelined      //
// Module       : pipe_MEM_WB               //
// Descrption   : MEM/WB Pipeline Regs      //
// Author       : Hrishikesh Belatikar      //
// Date         : November 26th 2021        //
//////////////////////////////////////////////

module pipe_MEM_WB (clk, rst,
                    
                    MEM_PC2, MEM_J_JAL_addr, MEM_EX_out, MEM_mem_data, MEM_branch_PC,
                    MEM_halt, MEM_mem_to_reg, MEM_J_JAL,
                    MEM_JR_JALR, MEM_JAL_JALR, MEM_rd_addr, MEM_reg_write,
                    
                    WB_PC2, WB_J_JAL_addr, WB_EX_out, WB_mem_data, WB_branch_PC,
                    WB_halt, WB_mem_to_reg, WB_J_JAL,
                    WB_JR_JALR, WB_JAL_JALR, WB_rd_addr, WB_reg_write);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input CLK & RST
		input   clk,
                rst;
    
    //Input Signals
        input  [15:0]   MEM_PC2,
                        MEM_J_JAL_addr,
                        MEM_EX_out,
                        MEM_mem_data,
                        MEM_branch_PC;

        input  [2:0]    MEM_rd_addr;

    //Input Control Signals
        input   MEM_halt,
                MEM_mem_to_reg,
                MEM_J_JAL,
                MEM_JR_JALR,
                MEM_JAL_JALR,
                MEM_reg_write;

    //Output Signals
        output  [15:0]  WB_PC2,
                        WB_J_JAL_addr,
                        WB_EX_out,
                        WB_mem_data,
                        WB_branch_PC;
        
        output  [2:0]   WB_rd_addr;

    //Input Control Signals
        output  WB_halt,
                WB_mem_to_reg,
                WB_JR_JALR,
                WB_J_JAL,
                WB_JAL_JALR,
                WB_reg_write;

/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
	wire muxed_halt;

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
    /////////////////////////////
    // Regs for Signal values //
    ///////////////////////////

	// Prog Counter + 2
    dff US0 [15:0] (.d(MEM_PC2), .q(WB_PC2), .clk(clk), .rst(rst));

    // Jump calculated Address
    dff US1 [15:0] (.d(MEM_J_JAL_addr), .q(WB_J_JAL_addr), .clk(clk), .rst(rst));

    // Value generated from execute block
    dff US4 [15:0] (.d(MEM_EX_out), .q(WB_EX_out), .clk(clk), .rst(rst));

    // Extracted memory data
    dff US5 [15:0] (.d(MEM_mem_data), .q(WB_mem_data), .clk(clk), .rst(rst));

    // Calculate branched addr
    dff US6 [15:0] (.d(MEM_branch_PC), .q(WB_branch_PC), .clk(clk), .rst(rst));

    // Registers Rd address for regfile
    dff US7 [2:0] (.d(MEM_rd_addr), .q(WB_rd_addr), .clk(clk), .rst(rst));

    ///////////////////////////////
    // Regs for Control Signals //
    /////////////////////////////
    assign muxed_halt = rst ? 1'b0 : MEM_halt;
    dff UC1  (.d(muxed_halt),        .q(WB_halt),        .clk(clk), .rst(rst)); //Halt signal 
    // dff UC2  (.d(MEM_exception),     .q(WB_exception),   .clk(clk), .rst(rst)); //Exception signal 
    dff UC3  (.d(MEM_mem_to_reg),    .q(WB_mem_to_reg),  .clk(clk), .rst(rst)); //Memory data to reg file signal 
    dff UC4  (.d(MEM_J_JAL),         .q(WB_J_JAL),       .clk(clk), .rst(rst)); //Jump instuction sigs
    dff UC5  (.d(MEM_JR_JALR),       .q(WB_JR_JALR),     .clk(clk), .rst(rst));
    dff UC6  (.d(MEM_JAL_JALR),      .q(WB_JAL_JALR),    .clk(clk), .rst(rst));
    dff UC10 (.d(MEM_reg_write),     .q(WB_reg_write),   .clk(clk), .rst(rst)); //Decides to write to reg or not

/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/
	//None
endmodule