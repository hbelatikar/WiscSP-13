/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */

module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input wire clk;
   input wire rst;

   output wire err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here */

   wire [15:0] PC2, ID_PC2, EX_PC2, MEM_PC2, WB_PC2,
               instr, ID_instr,

               EX_imm_16bit, ID_imm_16bit, MEM_imm_16bit,
               
               ID_read_reg_1, EX_read_reg_1,
               ID_read_reg_2, EX_read_reg_2, MEM_read_reg_2,
               ID_J_JAL_addr, EX_J_JAL_addr, MEM_J_JAL_addr, WB_J_JAL_addr,
               
               EX_EX_out, MEM_EX_out, WB_EX_out,
               MEM_mem_data, WB_mem_data,
               MEM_branch_PC, WB_branch_PC,
               early_branch_jump_addr,

               new_PC, EPC,
               write_back;

   wire [4:0]  op_code, ID_op_code, EX_op_code;

   wire [2:0]  ID_rs_addr, EX_rs_addr,
               ID_rt_addr, EX_rt_addr, MEM_rt_addr,
               ID_rd_addr, EX_rd_addr, MEM_rd_addr, WB_rd_addr;
   
   wire [1:0]  reg_instr_op;
   
   wire        EX_branch_sel, MEM_branch_sel;

   //Control Signals
   wire [4:0]  ID_ALU_fn, EX_ALU_fn;
   
   wire [1:0]  rd_sel, 
               forward_A, forward_B,
               storing_fwd, checker_fwd;

   wire        ID_halt, EX_halt, MEM_halt, WB_halt,
               imm_len,
               imm_sign,
               ID_reg_write, EX_reg_write, MEM_reg_write, WB_reg_write,
               ID_mem_write, EX_mem_write, MEM_mem_write,
               ID_mem_read, EX_mem_read, MEM_mem_read,
               ID_branch, EX_branch, MEM_branch,
               ID_mem_to_reg, EX_mem_to_reg, MEM_mem_to_reg, WB_mem_to_reg,
               ID_J_JAL, EX_J_JAL, MEM_J_JAL, WB_J_JAL,
               ID_JR_JALR, EX_JR_JALR, MEM_JR_JALR, WB_JR_JALR,
               ID_JAL_JALR, EX_JAL_JALR, MEM_JAL_JALR, WB_JAL_JALR,
               skip_rf_Rs, skip_rf_Rt,
               stall, branch_or_jump, 
               exception, RTI;

   assign err = 1'b0;

   //Instantiations
   IF_top IF0        (.clk(clk), .rst(rst), .stall(stall), .branch_or_jump(branch_or_jump), .EPC(EPC), .RTI(RTI),
                      .new_PC(early_branch_jump_addr), .PC2(PC2), .instr(instr), .halt(ID_halt), .exception(exception));
   
   pipe_IF_ID pIFID0 (.clk(clk), .rst(rst), .stall(stall), .flush(branch_or_jump | RTI | ID_halt | exception),
                      .PC2(PC2), .instr(instr), .ID_PC2(ID_PC2), .ID_instr(ID_instr));

   ID_top ID0        (.clk(clk), .rst(rst), 
                      .PC2(ID_PC2), .instr(ID_instr), .write_back(write_back), .J_JAL_addr(ID_J_JAL_addr), 
                      .imm_16bit(ID_imm_16bit), .read_reg_1(ID_read_reg_1), .read_reg_2(ID_read_reg_2),  
                      .op_code(ID_op_code), .reg_instr_op(reg_instr_op), .rd_sel(rd_sel), .reg_write(WB_reg_write), 
                      .imm_sign(imm_sign), .imm_len(imm_len), .exception(exception), .EPC(EPC),

                      .rs_addr(ID_rs_addr), .rt_addr(ID_rt_addr), .rd_addr(ID_rd_addr), .dest_addr(WB_rd_addr),
                      .EX_MEM_fwd_data(MEM_EX_out), .EX_EX_out(EX_EX_out), .early_branch_jump_addr(early_branch_jump_addr),
                      .J_JAL(ID_J_JAL), .JR_JALR(ID_JR_JALR), .JAL_JALR(ID_JAL_JALR), .branch_or_jump(branch_or_jump),
                      .skip_rf_Rs(skip_rf_Rs), .skip_rf_Rt(skip_rf_Rt), .storing_fwd(storing_fwd), .checker_fwd(checker_fwd));
   
   control_fsm CTRL (.op_code(ID_op_code), .reg_instr_op(reg_instr_op), .halt(ID_halt), .exception(exception), .RTI(RTI),
                     .reg_write(ID_reg_write), .imm_len(imm_len), .imm_sign(imm_sign), .mem_write(ID_mem_write), 
                     .mem_read(ID_mem_read), .branch(ID_branch), .mem_to_reg(ID_mem_to_reg), .J_JAL(ID_J_JAL), 
                     .JR_JALR(ID_JR_JALR), .JAL_JALR(ID_JAL_JALR), .rd_sel(rd_sel), .ALU_fn(ID_ALU_fn));

   pipe_ID_EX pIDEX0 (.clk(clk), .rst(rst), .stall(stall | exception | RTI),
                      
                      .ID_PC2(ID_PC2), .ID_J_JAL_addr(ID_J_JAL_addr), .ID_imm_16bit(ID_imm_16bit), .ID_read_reg_1(ID_read_reg_1),
                      .ID_read_reg_2(ID_read_reg_2), .ID_halt(ID_halt), .ID_mem_write(ID_mem_write), .ID_mem_read(ID_mem_read),
                      .ID_branch(ID_branch), .ID_mem_to_reg(ID_mem_to_reg), .ID_J_JAL(ID_J_JAL), .ID_JR_JALR(ID_JR_JALR), .ID_JAL_JALR(ID_JAL_JALR),
                      .ID_ALU_fn(ID_ALU_fn), .ID_rs_addr(ID_rs_addr), .ID_rt_addr(ID_rt_addr), .ID_rd_addr(ID_rd_addr), .ID_reg_write(ID_reg_write),
                      .ID_op_code(ID_op_code),
    
                      .EX_PC2(EX_PC2), .EX_J_JAL_addr(EX_J_JAL_addr), .EX_imm_16bit(EX_imm_16bit), .EX_read_reg_1(EX_read_reg_1),
                      .EX_read_reg_2(EX_read_reg_2), .EX_halt(EX_halt), .EX_mem_write(EX_mem_write), .EX_mem_read(EX_mem_read),
                      .EX_branch(EX_branch), .EX_mem_to_reg(EX_mem_to_reg), .EX_J_JAL(EX_J_JAL), .EX_JR_JALR(EX_JR_JALR), .EX_JAL_JALR(EX_JAL_JALR),
                      .EX_ALU_fn(EX_ALU_fn), .EX_rs_addr(EX_rs_addr), .EX_rt_addr(EX_rt_addr), .EX_rd_addr(EX_rd_addr), .EX_reg_write(EX_reg_write),
                      .EX_op_code(EX_op_code));

   EX_top EX0        (.read_reg_1(EX_read_reg_1), .read_reg_2(EX_read_reg_2), .imm_16bit(EX_imm_16bit), .PC2(EX_PC2), .JAL_JALR(EX_JAL_JALR),
                      .EX_MEM_fwd_data(MEM_EX_out), .write_back(write_back), .forward_A(forward_A), .forward_B(forward_B),
                      .ALU_fn(EX_ALU_fn), .EX_out(EX_EX_out), .branch_sel(EX_branch_sel));

   pipe_EX_MEM pEXMEM0 (.clk(clk), .rst(rst),

                        .EX_PC2(EX_PC2), .EX_J_JAL_addr(EX_J_JAL_addr), .EX_imm_16bit(EX_imm_16bit), .EX_read_reg_2(EX_read_reg_2), .EX_EX_out(EX_EX_out),
                        .EX_branch_sel(EX_branch_sel), .EX_halt(EX_halt), .EX_mem_write(EX_mem_write), .EX_mem_read(EX_mem_read),
                        .EX_branch(EX_branch), .EX_mem_to_reg(EX_mem_to_reg), .EX_J_JAL(EX_J_JAL), .EX_JR_JALR(EX_JR_JALR), .EX_JAL_JALR(EX_JAL_JALR),
                        .EX_rd_addr(EX_rd_addr), .EX_reg_write(EX_reg_write), .EX_rt_addr(EX_rt_addr),

                        .MEM_PC2(MEM_PC2), .MEM_J_JAL_addr(MEM_J_JAL_addr), .MEM_imm_16bit(MEM_imm_16bit), .MEM_read_reg_2(MEM_read_reg_2), 
                        .MEM_EX_out(MEM_EX_out), .MEM_branch_sel(MEM_branch_sel), .MEM_halt(MEM_halt),
                        .MEM_mem_write(MEM_mem_write), .MEM_mem_read(MEM_mem_read), .MEM_branch(MEM_branch), .MEM_mem_to_reg(MEM_mem_to_reg), 
                        .MEM_J_JAL(MEM_J_JAL), .MEM_JR_JALR(MEM_JR_JALR), .MEM_JAL_JALR(MEM_JAL_JALR), .MEM_rd_addr(MEM_rd_addr), 
                        .MEM_rt_addr(MEM_rt_addr),
                        .MEM_reg_write(MEM_reg_write));

   MEM_top MEM0      (.clk(clk), .rst(rst), .PC2(MEM_PC2), .imm_16bit(MEM_imm_16bit), .branch_sel(MEM_branch_sel), .EX_out(MEM_EX_out), 
                      .read_reg_2(MEM_read_reg_2), .branch(MEM_branch), .mem_write(MEM_mem_write), .mem_read(MEM_mem_read), 
                      .branch_PC(MEM_branch_PC), .mem_data(MEM_mem_data));

   pipe_MEM_WB pMEMWB0 (.clk(clk), .rst(rst),
                    
                        .MEM_PC2(MEM_PC2), .MEM_J_JAL_addr(MEM_J_JAL_addr), .MEM_EX_out(MEM_EX_out), .MEM_mem_data(MEM_mem_data), 
                        .MEM_branch_PC(MEM_branch_PC), .MEM_halt(MEM_halt), .MEM_mem_to_reg(MEM_mem_to_reg), 
                        .MEM_J_JAL(MEM_J_JAL), .MEM_JR_JALR(MEM_JR_JALR), .MEM_JAL_JALR(MEM_JAL_JALR), .MEM_rd_addr(MEM_rd_addr),
                        .MEM_reg_write(MEM_reg_write),

                        .WB_PC2(WB_PC2), .WB_J_JAL_addr(WB_J_JAL_addr), .WB_EX_out(WB_EX_out), .WB_mem_data(WB_mem_data), 
                        .WB_branch_PC(WB_branch_PC), .WB_halt(WB_halt), .WB_mem_to_reg(WB_mem_to_reg), 
                        .WB_J_JAL(WB_J_JAL),.WB_JR_JALR(WB_JR_JALR), .WB_JAL_JALR(WB_JAL_JALR), .WB_rd_addr(WB_rd_addr), 
                        .WB_reg_write(WB_reg_write));

   WB_top WB0        (.branch_PC(WB_branch_PC), .J_JAL_addr(WB_J_JAL_addr), .EX_out(WB_EX_out), .mem_data(WB_mem_data), .PC2(WB_PC2), 
                      .mem_to_reg(WB_mem_to_reg), .J_JAL(WB_J_JAL), .JR_JALR(WB_JR_JALR), .JAL_JALR(WB_JAL_JALR), .new_PC(new_PC), .write_back(write_back));

   frwrd_block FWD0  (.EX_rs_addr(EX_rs_addr), .EX_rt_addr(EX_rt_addr), .EX_rd_addr(EX_rd_addr), .MEM_rd_addr(MEM_rd_addr), 
                      .WB_rd_addr(WB_rd_addr), .MEM_reg_write(MEM_reg_write), .WB_reg_write(WB_reg_write), .EX_reg_write(EX_reg_write),
                      .ID_rs_addr(ID_rs_addr), .ID_rt_addr(ID_rt_addr), .ID_mem_write(ID_mem_write), .branch(ID_branch),
                      .forward_A(forward_A), .forward_B(forward_B), .skip_rf_Rs(skip_rf_Rs), .skip_rf_Rt(skip_rf_Rt),
                      .storing_fwd(storing_fwd), .checker_fwd(checker_fwd), .JR_JALR(ID_JR_JALR));

   hazard_block HZD  (.EX_mem_read(EX_mem_read), .EX_rt_addr(EX_rt_addr), .ID_rs_addr(ID_rs_addr), .ID_rt_addr(ID_rt_addr), 
                      .ID_mem_write(ID_mem_write), .ID_mem_read(ID_mem_read), .EX_mem_write(EX_mem_write), .MEM_mem_read(MEM_mem_read),
                      .MEM_mem_write(MEM_mem_write), .ID_op_code(ID_op_code), .MEM_rt_addr(MEM_rt_addr),
                      .stall(stall));

endmodule // proc
// DUMMY LINE FOR REV CONTROL :0: