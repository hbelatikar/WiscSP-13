//////////////////////////////////////////////
// Project      : WiscSP13 - Pipelined      //
// Module       : pipe_ID_EX                //
// Descrption   : ID/EX Pipeline Regs       //
// Author       : Hrishikesh Belatikar      //
// Date         : November 26th 2021        //
//////////////////////////////////////////////

module pipe_ID_EX  (clk, rst, stall,
                    
                    ID_PC2, ID_J_JAL_addr, ID_imm_16bit, ID_read_reg_1,
                    ID_read_reg_2, ID_halt, ID_mem_write, ID_mem_read,
                    ID_branch, ID_mem_to_reg, ID_J_JAL, ID_JR_JALR, ID_JAL_JALR,
                    ID_ALU_fn, ID_op_code,
                    ID_rs_addr, ID_rt_addr, ID_rd_addr, ID_reg_write,

                    EX_PC2, EX_J_JAL_addr, EX_imm_16bit, EX_read_reg_1,
                    EX_read_reg_2, EX_halt, EX_mem_write, EX_mem_read,
                    EX_branch, EX_mem_to_reg, EX_J_JAL, EX_JR_JALR, EX_JAL_JALR,
                    EX_ALU_fn, EX_op_code,
                    EX_rs_addr, EX_rt_addr, EX_rd_addr, EX_reg_write);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input CLK & RST
		input   clk,
                rst;

    //Input Signals
        input   [15:0]  ID_PC2,
                        ID_J_JAL_addr,
                        ID_imm_16bit,
                        ID_read_reg_1,
                        ID_read_reg_2;

        input   [4:0]   ID_op_code;
        
        input   [2:0]   ID_rs_addr,
                        ID_rt_addr,
                        ID_rd_addr;
        
        input           ID_reg_write, stall;

    //Input Control Signals
        input   ID_halt,
                ID_mem_write,
                ID_mem_read,
                ID_branch,
                ID_mem_to_reg,
                ID_J_JAL,
                ID_JR_JALR,
                ID_JAL_JALR;
        
        input [4:0] ID_ALU_fn;

    //Output Control Signals
        output [4:0] EX_ALU_fn;
        output [4:0] EX_op_code;
        
        output  EX_halt,
                EX_mem_write,
                EX_mem_read,
                EX_branch,
                EX_mem_to_reg,
                EX_J_JAL,
                EX_JR_JALR,
                EX_JAL_JALR;
        
    //Output Signals
        output  [15:0]  EX_PC2,
                        EX_J_JAL_addr,
                        EX_imm_16bit,
                        EX_read_reg_1,
                        EX_read_reg_2;
        
        output   [2:0]  EX_rs_addr,
                        EX_rt_addr,
                        EX_rd_addr;

        output          EX_reg_write;
        

/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
	wire    stalled_halt, stalled_mem_write, 
            stalled_mem_read, stalled_branch, stalled_mem_to_reg,
            stalled_J_JAL, stalled_JR_JALR, stalled_JAL_JALR,
            stalled_reg_write;
    wire [4:0] stalled_ALU_fn;

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
    /////////////////////////////
    // Regs for Signal values //
    ///////////////////////////

	// Prog Counter + 2
    dff US0 [15:0]  (.d(ID_PC2), .q(EX_PC2), .clk(clk), .rst(rst));

    // Jump calculated Address
    dff US1 [15:0]  (.d(ID_J_JAL_addr), .q(EX_J_JAL_addr),  .clk(clk),  .rst(rst));

    // Immidiate 16 bit Extended Value
    dff US2 [15:0]  (.d(ID_imm_16bit), .q(EX_imm_16bit),    .clk(clk),  .rst(rst));

    // Value read from Register 1
    dff US3 [15:0]  (.d(ID_read_reg_1), .q(EX_read_reg_1),  .clk(clk),  .rst(rst));
    
    // Value read from Register 2
    dff US4 [15:0]  (.d(ID_read_reg_2), .q(EX_read_reg_2),  .clk(clk),  .rst(rst));

    // Register Rs Address
    dff US5 [2:0]   (.d(ID_rs_addr),    .q(EX_rs_addr),     .clk(clk),  .rst(rst));
    
    // Register Rt Address
    dff US6 [2:0]   (.d(ID_rt_addr),    .q(EX_rt_addr),     .clk(clk),  .rst(rst));

    // Register Rd Address
    dff US7 [2:0]   (.d(ID_rd_addr),    .q(EX_rd_addr),     .clk(clk),  .rst(rst));

    ///////////////////////////////
    // Regs for Control Signals //
    /////////////////////////////

    //ALU function control signals
    assign stalled_ALU_fn = stall ? 5'h1F : ID_ALU_fn;
    dff UC0 [4:0] (.d(stalled_ALU_fn), .q(EX_ALU_fn), .clk(clk), .rst(rst));
    
    assign stalled_halt = (rst|stall) ? 1'b0 : ID_halt;
    dff UC1  (.d(stalled_halt),  .q(EX_halt),        .clk(clk), .rst(rst)); //Halt signal 
    
    // assign stalled_exception = stall ? 1'b0 : ID_exception;
    // dff UC2  (.d(stalled_exception),  .q(EX_exception),   .clk(clk), .rst(rst)); //Exception signal 
    
    assign stalled_mem_write = stall ? 1'b0 : ID_mem_write;
    dff UC3  (.d(stalled_mem_write),  .q(EX_mem_write),   .clk(clk), .rst(rst)); //Write into memory? signal 
     
    assign stalled_mem_read = stall ? 1'b0 : ID_mem_read;
    dff UC4  (.d(stalled_mem_read),   .q(EX_mem_read),    .clk(clk), .rst(rst)); //Read from memory? signal 
    
    assign stalled_branch = stall ? 1'b0 : ID_branch;
    dff UC5  (.d(stalled_branch),     .q(EX_branch),      .clk(clk), .rst(rst)); //Branch instr? signal
    
    assign stalled_mem_to_reg = stall ? 1'b0 : ID_mem_to_reg;
    dff UC6  (.d(stalled_mem_to_reg), .q(EX_mem_to_reg),  .clk(clk), .rst(rst)); //Memory data to reg file signal 
    
    assign stalled_J_JAL = stall ? 1'b0 : ID_J_JAL;
    dff UC7  (.d(stalled_J_JAL),      .q(EX_J_JAL),       .clk(clk), .rst(rst)); //Jump instuction sigs
    
    assign stalled_JR_JALR = stall ? 1'b0 : ID_JR_JALR;
    dff UC8  (.d(stalled_JR_JALR),    .q(EX_JR_JALR),     .clk(clk), .rst(rst));
    
    assign stalled_JAL_JALR = stall ? 1'b0 : ID_JAL_JALR;
    dff UC9  (.d(stalled_JAL_JALR),   .q(EX_JAL_JALR),    .clk(clk), .rst(rst));
    
    assign stalled_reg_write = stall ? 1'b0 : ID_reg_write;
    dff UC10 (.d(stalled_reg_write),  .q(EX_reg_write),   .clk(clk), .rst(rst)); //Write to register signal

/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/
	
endmodule