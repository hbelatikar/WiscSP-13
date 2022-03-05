//////////////////////////////////////////////
// Project      : WiscSP13 - Unpipelined    //
// Module       : ID_top                    //
// Description  : Decodes the instruction   //
// Author       : Hrishikesh Belatikar      //
// Date         : November 5th 2021         //
//////////////////////////////////////////////

module ID_top  (clk, rst, PC2, instr, write_back, 
                J_JAL_addr, imm_16bit, read_reg_1,
                read_reg_2, op_code, reg_instr_op, exception,
                J_JAL, JR_JALR, JAL_JALR, branch_or_jump, early_branch_jump_addr,
                rd_sel, reg_write, imm_sign, imm_len, EX_EX_out, EPC,
                rs_addr, rt_addr, rd_addr, dest_addr, EX_MEM_fwd_data,
                skip_rf_Rs, skip_rf_Rt, storing_fwd, checker_fwd);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input Clock & Reset
    input wire  clk,
                rst;

    //Input Signals
    input wire [15:0]   PC2,
                        instr,
                        write_back,
                        EX_MEM_fwd_data,
                        EX_EX_out;
    
    //Input Control Signals
    input wire  reg_write,
                imm_sign,
                imm_len,
                J_JAL, 
                JR_JALR, 
                JAL_JALR,
                exception; 

    input wire [1:0] rd_sel;

    input wire [2:0] dest_addr;
    
    input wire [1:0]    storing_fwd, checker_fwd;

    input wire          skip_rf_Rs,
                        skip_rf_Rt;
    //Output Signals
    output wire [15:0]  J_JAL_addr,
                        imm_16bit,
                        read_reg_1,
                        read_reg_2,
                        early_branch_jump_addr,
                        EPC;

    output wire [4:0]   op_code;

    output wire [2:0]   rs_addr,    //Output sigs for forward checking
                        rt_addr,
                        rd_addr;
    
    output wire [1:0]   reg_instr_op;

    output wire branch_or_jump;
/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
    wire [15:0] J_extended_addr, early_branch_addr, JR_JALR_addr, 
                read_from_reg_1, read_from_reg_2, exception_addr; 
    wire [10:0] J_unextended_addr;      //Jump addr extracted from Instr Instr [11:0]
    wire [7:0]  imm_data_unextended;    //Imm data extracted from Instr Instr[7:0]
    wire [2:0]  reg1_addr,              //Instr[10:8]
                reg2_addr,              //Instr[7:5]
                rd_regI_addr,           //Instr[4:2]
                writereg_addr;          //Selected by the 4:1 mux
    
    wire [1:0] branch_J_addr_sel;
    
    wire        err_rf, err_J_JAL_addr, err_JR_JALR_addr, err_early_branch_addr, 
                take_branch, take_jump;

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
    rf              iREGF  (.read1data(read_from_reg_1), .read2data(read_from_reg_2), .read1regsel(reg1_addr), .read2regsel(reg2_addr),
                            .writeregsel(dest_addr), .writedata(write_back), .write(reg_write ), //| JAL_JALRTesting JAL_JALR HOTFIX!
                            .err(err_rf), .clk(clk), .rst(rst));
    
    extender_block  iXTND  (.data_in(imm_data_unextended), .extended_data(imm_16bit), .imm_len(imm_len), .imm_sign(imm_sign));

    erly_brnch_chkr iEBR   (.reg_to_check(read_reg_1), .branch_opcode(op_code), .take_branch(take_branch));

    mux_4_1_3bit    iMUX0  (.in0(reg2_addr), .in1(rd_regI_addr), .in2(reg1_addr), .in3(3'b111), .sel(rd_sel), .out0(writereg_addr));

    mux_4_1_16bit   iMUX1  (.in0(early_branch_addr), .in1(J_JAL_addr), .in2(JR_JALR_addr), .in3(16'h0), .sel(branch_J_addr_sel), .out0(early_branch_jump_addr));
                            
    CLA_16bit   CLA0    (.A(PC2), .B(J_extended_addr), .Cin(1'b0), .S(J_JAL_addr), .Cout(err_J_JAL_addr));  //Generated J_JAL_addr

    CLA_16bit   CLA1    (.A(PC2), .B(imm_16bit), .Cin(1'b0), .S(early_branch_addr), .Cout(err_early_branch_addr));  //Generated branch_addr (branch_PC)

    CLA_16bit   CLA2    (.A(read_reg_1), .B(imm_16bit), .Cin(1'b0), .S(JR_JALR_addr), .Cout(err_JR_JALR_addr));
    
    //Exception PC
    assign exception_addr = exception ? PC2 : EPC;
    dff EPC0 [15:0] (.d(exception_addr), .q(EPC), .clk(clk), .rst(rst));
    
/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/
    //Decode the recieved instructions
    wire [4:0] resetted_op_code;    
    assign resetted_op_code = rst ? 5'h01 : instr[15:11];
    assign op_code  = resetted_op_code;
    
    assign reg_instr_op = instr[1:0];
    
    assign J_unextended_addr = instr[10:0];
    assign J_extended_addr = { {5{J_unextended_addr[10]}} ,  J_unextended_addr };
    
    assign imm_data_unextended = instr[7:0];
    
    assign reg1_addr = instr[10:8];
    assign reg2_addr = instr[7:5];
    assign rd_regI_addr = instr[4:2];

    assign rs_addr = reg1_addr;
    assign rt_addr = reg2_addr;
    assign rd_addr = writereg_addr;

    //Signals to notify signal that the next PC should be differents
    assign take_jump = J_JAL | JR_JALR | JAL_JALR;
    assign branch_or_jump = take_branch | take_jump;

    //Select which addr is to be routed back to PC
    assign branch_J_addr_sel =  take_branch ? 2'b00 :
                                J_JAL       ? 2'b01 :
                                JR_JALR     ? 2'b10 :
                                2'b11;
 
    //assign read_reg_1 = skip_rf_Rs ? write_back : read_from_reg_1;
    
    //Decode the forwarding logic if any
    assign read_reg_1 = (checker_fwd == 2'b10)                ? EX_EX_out        :
                        (checker_fwd == 2'b01)                ? EX_MEM_fwd_data  : //EX_MEM_read_reg_1
                        (skip_rf_Rs | (checker_fwd == 2'b11)) ? write_back       : 
                                                                read_from_reg_1  ;

    // assign fwded_PC2 =  (checker_fwd == 2'b10)                ? EX_PC2          :
    //                     (checker_fwd == 2'b01)                ? MEM_PC2         : //EX_MEM_read_reg_1
    //                     (skip_rf_Rs | (checker_fwd == 2'b11)) ? WB_PC2          : 
    //                                                             read_from_reg_1 ;
    // assign final_read_reg_1 = JAL_JALR ? fwded_PC2 : read_reg_1;


    assign read_reg_2 = (storing_fwd == 2'b10)                ? EX_EX_out        :
                        (storing_fwd == 2'b01)                ? EX_MEM_fwd_data  : //EX_MEM_read_reg_2
                        (skip_rf_Rt | (storing_fwd == 2'b11)) ? write_back       : 
                                                                read_from_reg_2  ;

endmodule
