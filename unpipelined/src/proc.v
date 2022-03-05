/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here */

   wire [15:0] PC2,
               instr,

               imm_16bit,
               read_reg_1,
               read_reg_2,
               J_JAL_addr,
               
               EX_out,
               mem_data,
               branch_PC,

               new_PC,
               write_back;

   wire [4:0]  op_code;
   
   wire [1:0]  reg_instr_op;
   
   wire        branch_sel;

   //Control Signals
   wire [4:0]  ALU_fn;
   
   wire [1:0]  rd_sel;

   wire        halt,
               exception,
               reg_write,
               imm_len,
               imm_sign,
               mem_write,
               mem_read,
               branch,
               mem_to_reg,
               J_JAL,
               JR_JALR,
               JAL_JALR;

   assign err = 1'b0;

   //Instantiations
   IF_top IF0   (.clk(clk), .rst(rst), .new_PC(new_PC), .PC2(PC2), .instr(instr), .halt(halt), .exception(exception));
   
   ID_top ID0   (.clk(clk), .rst(rst), .PC2(PC2), .instr(instr), .write_back(write_back),.J_JAL_addr(J_JAL_addr), 
                   .imm_16bit(imm_16bit), .read_reg_1(read_reg_1), .read_reg_2(read_reg_2), .op_code(op_code), 
                   .reg_instr_op(reg_instr_op), .rd_sel(rd_sel), .reg_write(reg_write), .imm_sign(imm_sign), .imm_len(imm_len));
   
   EX_top EX0   (.read_reg_1(read_reg_1), .read_reg_2(read_reg_2), .imm_16bit(imm_16bit), .ALU_fn(ALU_fn), .EX_out(EX_out), .branch_sel(branch_sel));

   MEM_top MEM0  (.clk(clk), .rst(rst), .PC2(PC2), .imm_16bit(imm_16bit), .branch_sel(branch_sel), .EX_out(EX_out), 
                   .read_reg_2(read_reg_2), .branch(branch), .mem_write(mem_write), .mem_read(mem_read), .branch_PC(branch_PC), .mem_data(mem_data));

   WB_top WB0   (.branch_PC(branch_PC), .J_JAL_addr(J_JAL_addr), .EX_out(EX_out), .mem_data(mem_data), .PC2(PC2), 
                   .mem_to_reg(mem_to_reg), .J_JAL(J_JAL), .JR_JALR(JR_JALR), .JAL_JALR(JAL_JALR), .new_PC(new_PC), .write_back(write_back));

   control_fsm CTRL (.op_code(op_code), .reg_instr_op(reg_instr_op), .halt(halt), .exception(exception), .reg_write(reg_write), .imm_len(imm_len), .imm_sign(imm_sign), 
                     .mem_write(mem_write), .mem_read(mem_read), .branch(branch), .mem_to_reg(mem_to_reg), .J_JAL(J_JAL), .JR_JALR(JR_JALR), .JAL_JALR(JAL_JALR), .rd_sel(rd_sel), .ALU_fn(ALU_fn));

endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
