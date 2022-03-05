//////////////////////////////////////////////
// Project      : WiscSP13 - Pipelined      //
// Module       : pipe_EX_MEM               //
// Descrption   : EX/MEM Pipeline Regs      //
// Author       : Hrishikesh Belatikar      //
// Date         : November 26th 2021        //
//////////////////////////////////////////////

module pipe_EX_MEM  (clk, rst,

                    EX_PC2, EX_J_JAL_addr, EX_imm_16bit, EX_read_reg_2, EX_EX_out,
                    EX_branch_sel, EX_halt, EX_mem_write, EX_mem_read,
                    EX_branch, EX_mem_to_reg, EX_J_JAL, EX_JR_JALR, EX_JAL_JALR,
                    EX_rd_addr, EX_reg_write, EX_rt_addr,

                    MEM_PC2, MEM_J_JAL_addr, MEM_imm_16bit, MEM_read_reg_2, MEM_EX_out,
                    MEM_branch_sel, MEM_halt, MEM_mem_write, MEM_mem_read,
                    MEM_branch, MEM_mem_to_reg, MEM_J_JAL, MEM_JR_JALR, MEM_JAL_JALR,
                    MEM_rt_addr,
                    MEM_rd_addr, MEM_reg_write);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input CLK & RST
		input   clk,
                rst;
    
    //Input Signals
        input  [15:0]   EX_PC2,
                        EX_J_JAL_addr,
                        EX_imm_16bit,
                        EX_read_reg_2,
                        EX_EX_out;
        
        input   [2:0]   EX_rd_addr,
                        EX_rt_addr;

        input           EX_branch_sel;
    //Input Control Signals
        input   EX_halt,
                EX_mem_write,
                EX_mem_read,
                EX_branch,
                EX_mem_to_reg,
                EX_J_JAL,
                EX_JR_JALR,
                EX_JAL_JALR,
                EX_reg_write;

    //Output Signals

        output  [15:0]  MEM_PC2,
                        MEM_J_JAL_addr,
                        MEM_imm_16bit,
                        MEM_read_reg_2,
                        MEM_EX_out;

        output  [2:0]   MEM_rd_addr,
                        MEM_rt_addr;

        output          MEM_branch_sel;
    //Input Control Signals
        output  MEM_halt,
                MEM_mem_write,
                MEM_mem_read,
                MEM_branch,
                MEM_mem_to_reg,
                MEM_J_JAL,
                MEM_JR_JALR,
                MEM_JAL_JALR,
                MEM_reg_write;

/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
	//None

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
    /////////////////////////////
    // Regs for Signal values //
    ///////////////////////////

	// Prog Counter + 2
    dff US0 [15:0] (.d(EX_PC2), .q(MEM_PC2), .clk(clk), .rst(rst));

    // Jump calculated Address
    dff US1 [15:0] (.d(EX_J_JAL_addr), .q(MEM_J_JAL_addr), .clk(clk), .rst(rst));

    // Immidiate 16 bit Extended Value
    dff US2 [15:0] (.d(EX_imm_16bit), .q(MEM_imm_16bit), .clk(clk), .rst(rst));

    // Value read from Register 2
    dff US4 [15:0] (.d(EX_read_reg_2), .q(MEM_read_reg_2), .clk(clk), .rst(rst));

    // Value generated from execute block
    dff US5 [15:0] (.d(EX_EX_out), .q(MEM_EX_out), .clk(clk), .rst(rst));
    
    // Registers Rd address for regfile
    dff US6 [2:0] (.d(EX_rd_addr), .q(MEM_rd_addr), .clk(clk), .rst(rst));
    
    // Registers Rt address for regfile
    dff US8 [2:0] (.d(EX_rt_addr), .q(MEM_rt_addr), .clk(clk), .rst(rst));

    //Branch select?
    dff US7 (.d(EX_branch_sel), .q(MEM_branch_sel), .clk(clk), .rst(rst));

    ///////////////////////////////
    // Regs for Control Signals //
    /////////////////////////////
    assign muxed_halt = rst ? 1'b0 : EX_halt;
    dff UC1  (.d(muxed_halt),       .q(MEM_halt),        .clk(clk), .rst(rst)); //Halt signal 
    // dff UC2  (.d(EX_exception),     .q(MEM_exception),   .clk(clk), .rst(rst)); //Exception signal 
    dff UC3  (.d(EX_mem_write),     .q(MEM_mem_write),   .clk(clk), .rst(rst)); //Write into memory? signal 
    dff UC4  (.d(EX_mem_read),      .q(MEM_mem_read),    .clk(clk), .rst(rst)); //Read from memory? signal 
    dff UC5  (.d(EX_branch),        .q(MEM_branch),      .clk(clk), .rst(rst)); //Branch instr? signal
    dff UC6  (.d(EX_mem_to_reg),    .q(MEM_mem_to_reg),  .clk(clk), .rst(rst)); //Memory data to reg file signal 
    dff UC7  (.d(EX_J_JAL),         .q(MEM_J_JAL),       .clk(clk), .rst(rst)); //Jump instuction sigs
    dff UC8  (.d(EX_JR_JALR),       .q(MEM_JR_JALR),     .clk(clk), .rst(rst));
    dff UC9  (.d(EX_JAL_JALR),      .q(MEM_JAL_JALR),    .clk(clk), .rst(rst));
    dff UC10 (.d(EX_reg_write),     .q(MEM_reg_write),   .clk(clk), .rst(rst)); //Decides to write to reg or not

/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/
	//None
endmodule