//////////////////////////////////////////////
// Project      : WiscSP13 - Unpipelined    //
// Module       : control_fsm               //
// Descrption   : Provides control signal   //
//              : to the processor          //
// Author       : Hrishikesh Belatikar      //
// Date         : November 7th 2021         //
//////////////////////////////////////////////

module control_fsm ( op_code, reg_instr_op, halt, exception, reg_write, imm_len, imm_sign, RTI, 
                     mem_write, mem_read, branch, mem_to_reg, J_JAL, JR_JALR, JAL_JALR, rd_sel, ALU_fn);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input CLK & RST

    //Input Signals
    
    //Input Control Signals
    input wire  [4:0]   op_code;

    input wire  [1:0]   reg_instr_op;
    
    //Output Control Signals
    output  reg     halt,
                    exception,
                    RTI,
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
                    //fwd_reqd;
    
    output  reg  [1:0] rd_sel;
    
    output  reg  [4:0] ALU_fn;
    
/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
	localparam  [4:0]   ALU_HALT_NOP    = 5'b1_1111,

                        ALU_ADDI        = 5'b0_0000,
                        ALU_SUBI        = 5'b0_0001, 
                        ALU_XORI        = 5'b0_0010,
                        ALU_ANDNI       = 5'b0_0011,
                        ALU_ROLI        = 5'b0_0100,
                        ALU_SLLI        = 5'b0_0101,
                        ALU_RORI        = 5'b0_0110,
                        ALU_SRLI        = 5'b0_0111,
    
                        ALU_MEM_OPS     = 5'b0_1000,
                        ALU_BTR         = 5'b0_1001,
                        ALU_ADD         = 5'b0_1010,
                        ALU_SUB         = 5'b0_1011,
                        ALU_XOR         = 5'b0_1100,
                        ALU_ANDN        = 5'b0_1101,
                        ALU_ROL         = 5'b0_1110,
                        ALU_SLL         = 5'b0_1111,
    
                        ALU_ROR         = 5'b1_0000,
                        ALU_SRL         = 5'b1_0001,
                        ALU_SEQ         = 5'b1_0010,
                        ALU_SLT         = 5'b1_0011,
                        ALU_SLE         = 5'b1_0100,
                        ALU_SCO         = 5'b1_0101,
                        ALU_BEQZ        = 5'b1_0110,
                        ALU_BNEZ        = 5'b1_0111,
    
                        ALU_BLTZ        = 5'b1_1000,
                        ALU_BGEZ        = 5'b1_1001,
                        ALU_LBI         = 5'b1_1010,
                        ALU_SLBI        = 5'b1_1011,
                        ALU_J           = 5'b1_1100,
                        ALU_JR          = 5'b1_1101;

    localparam [4:0]    HALT    = 5'h00,
                        NOP     = 5'h01,
                        ADDI    = 5'h08,
                        SUBI    = 5'h09,
                        XORI    = 5'h0A,
                        ANDNI   = 5'h0B,
                        ROLI    = 5'h14,
                        SLLI    = 5'h15,
                        RORI    = 5'h16,
                        SRLI    = 5'h17,
                        ST      = 5'h10,
                        LD      = 5'h11,
                        STU     = 5'h13,
                        BTR     = 5'h19,
                        ARITH_R = 5'h1B,
                        SHIFT_R = 5'h1A,
                        SEQ     = 5'h1C,
                        SLT     = 5'h1D,
                        SLE     = 5'h1E,
                        SCO     = 5'h1F,
                        BEQZ    = 5'h0C,
                        BNEZ    = 5'h0D,
                        BLTZ    = 5'h0E,
                        BGEZ    = 5'h0F,
                        LBI     = 5'h18,
                        SLBI    = 5'h12,
                        J       = 5'h04,
                        JAL     = 5'h06,
                        JR      = 5'h05,
                        JALR    = 5'h07,
                        SIIC    = 5'h02,
                        RTI_INSTR     = 5'h03;

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
	//None

/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/
	always @(*) begin
        
        halt = 1'b0;
        exception = 1'b0;
        RTI = 1'b0;
        rd_sel = 2'b00;
        reg_write = 1'b0;
        imm_len = 1'b0;
        imm_sign = 1'b0;
        mem_write = 1'b0;
        mem_read = 1'b0;
        branch = 1'b0;
        mem_to_reg = 1'b0;
        J_JAL = 1'b0;
        JR_JALR = 1'b0;
        JAL_JALR = 1'b0;
        //fwd_reqd = 1'b0;
        ALU_fn = 5'h1F;

        case (op_code)
            HALT : begin
                halt = 1'b1;
            end 

            // NOP  : begin
            //     ALU_fn = ;
            // end

            ADDI : begin
                reg_write = 1'b1;
                imm_len = 1'b1;
                imm_sign = 1'b1;
                //fwd_reqd = 1'b1;
                ALU_fn = ALU_ADDI;
            end

            SUBI : begin
                reg_write = 1'b1;
                imm_len = 1'b1;
                imm_sign = 1'b1;
                //fwd_reqd = 1'b1;
                ALU_fn = ALU_SUBI;
            end

            XORI : begin
                reg_write = 1'b1;
                imm_len = 1'b1;
                //fwd_reqd = 1'b1;
                ALU_fn = ALU_XORI;
            end

            ANDNI : begin
                reg_write = 1'b1;
                imm_len = 1'b1;
                //fwd_reqd = 1'b1;
                ALU_fn = ALU_ANDNI;
            end

            ROLI : begin
                reg_write = 1'b1;
                imm_len = 1'b1;
                //fwd_reqd = 1'b1;
                ALU_fn = ALU_ROLI;
            end

            SLLI : begin
                reg_write = 1'b1;
                imm_len = 1'b1;
                //fwd_reqd = 1'b1;
                ALU_fn = ALU_SLLI;
            end

            RORI : begin
                reg_write = 1'b1;
                imm_len = 1'b1;
                ALU_fn = ALU_RORI;
            end
            
            SRLI : begin
                reg_write = 1'b1;
                imm_len = 1'b1;
                //fwd_reqd = 1'b1;
                ALU_fn = ALU_SRLI;
            end

            ST : begin
                imm_len = 1'b1;
                imm_sign = 1'b1;
                mem_write = 1'b1;
                //fwd_reqd = 1'b1;
                ALU_fn = ALU_ADDI;
            end

            LD : begin
                reg_write = 1'b1;
                imm_len = 1'b1;
                imm_sign = 1'b1;
                mem_read = 1'b1;
                mem_to_reg = 1'b1;
                //fwd_reqd = 1'b1;
                ALU_fn = ALU_ADDI;
            end

            STU : begin
                rd_sel = 2'b10;
                reg_write = 1'b1;
                imm_len = 1'b1;
                imm_sign = 1'b1;
                mem_write = 1'b1;
                //fwd_reqd = 1'b1;
                ALU_fn = ALU_ADDI;
            end

            BTR : begin
                rd_sel = 2'b01;
                reg_write = 1'b1;
                //fwd_reqd = 1'b1;
                ALU_fn = ALU_BTR;
            end

            SEQ : begin
                rd_sel = 2'b01;
                reg_write = 1'b1;
                //fwd_reqd = 1'b1;
                ALU_fn = ALU_SEQ;
            end

            SLT : begin
                rd_sel = 2'b01;
                reg_write = 1'b1;
                //fwd_reqd = 1'b1;
                ALU_fn = ALU_SLT;
            end

            SLE : begin
                rd_sel = 2'b01;
                reg_write = 1'b1;
                //fwd_reqd = 1'b1;
                ALU_fn = ALU_SLE;
            end

            SCO : begin
                rd_sel = 2'b01;
                reg_write = 1'b1;
                //fwd_reqd = 1'b1;
                ALU_fn = ALU_SCO;
            end

            BEQZ : begin
                imm_sign = 1'b1;
                branch = 1'b1;
                ALU_fn = ALU_BEQZ;
            end

            BNEZ : begin
                imm_sign = 1'b1;
                branch = 1'b1;
                ALU_fn = ALU_BNEZ;
            end

            BLTZ : begin
                imm_sign = 1'b1;
                branch = 1'b1;
                ALU_fn = ALU_BLTZ;
            end

            BGEZ : begin
                imm_sign = 1'b1;
                branch = 1'b1;
                ALU_fn = ALU_BGEZ;
            end

            LBI : begin
                rd_sel = 2'b10;
                reg_write = 1'b1;
                imm_sign = 1'b1;
                ALU_fn = ALU_LBI;
            end
            
            SLBI : begin
                rd_sel = 2'b10;
                reg_write = 1'b1;
                ALU_fn = ALU_SLBI;
            end

            J : begin
                J_JAL = 1'b1;
                imm_sign = 1'b1;
                ALU_fn = ALU_J;
            end

            JAL : begin
                rd_sel = 2'b11;
                reg_write = 1'b1;
                J_JAL = 1'b1;
                JAL_JALR = 1'b1;
                imm_sign = 1'b1;
                ALU_fn = ALU_J;
            end

            JR : begin
                JR_JALR = 1'b1;
                imm_sign = 1'b1;
                ALU_fn = ALU_JR;
            end

            JALR : begin
                rd_sel = 2'b11;
                reg_write = 1'b1;
                JR_JALR = 1'b1;
                JAL_JALR = 1'b1;
                imm_sign = 1'b1;
                ALU_fn = ALU_JR;
            end

            SIIC : begin
                exception = 1'b1;
                ALU_fn = 5'h1F;
            end

            RTI_INSTR : begin
                RTI = 1'b1;
                ALU_fn = 5'h1F;
            end
            
            ARITH_R : begin
                rd_sel = 2'b01;
                reg_write = 1'b1;
                case (reg_instr_op)
                    2'b00 : ALU_fn = ALU_ADD; 
                    2'b01 : ALU_fn = ALU_SUB; 
                    2'b10 : ALU_fn = ALU_XOR; 
                    2'b11 : ALU_fn = ALU_ANDN; 
                    // default: ALU_fn = ALU_ADD;
                endcase
            end

            SHIFT_R : begin
                rd_sel = 2'b01;
                reg_write = 1'b1;
                case (reg_instr_op)
                    2'b00 : ALU_fn = ALU_ROL; 
                    2'b01 : ALU_fn = ALU_SLL; 
                    2'b10 : ALU_fn = ALU_ROR; 
                    2'b11 : ALU_fn = ALU_SRL; 
                    // default: ALU_fn = ALU_ROL;
                endcase
            end

            //Default :- Do Nothing - NOP
            default: begin
                halt = 1'b0;
                exception = 1'b0;
                rd_sel = 2'b00;
                reg_write = 1'b0;
                imm_len = 1'b0;
                imm_sign = 1'b0;
                mem_write = 1'b0;
                mem_read = 1'b0;
                branch = 1'b0;
                mem_to_reg = 1'b0;
                J_JAL = 1'b0;
                JR_JALR = 1'b0;
                ALU_fn = 5'h1F;
            end
        endcase
    end
    
endmodule
