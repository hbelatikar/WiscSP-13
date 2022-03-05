//////////////////////////////////////////////
// Project      : WiscSP13 - Unpipelined    //
// Module       : ALU_control               //
// Descrption   : Controls internal EX as   //
//              : per the control FSM signs //
// Author       : Hrishikesh Belatikar      //
// Date         : November 7th 2021         //
//////////////////////////////////////////////

module ALU_control (ALU_fn, imm_rt_sel, SLBI, LBI, branch_en, ALU_op, sign, 
                    inv_A, inv_B, C_in, set_typ, set_en, branch_typ, btr);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input CLK & RST
		//None

    //Input Signals
        //None

    //Input Control Signals
        input   wire    [4:0]   ALU_fn;
    //Output Signals
        output  reg             imm_rt_sel,
        			 LBI,
                                SLBI,
                                branch_en,
                                sign,
                                inv_A,
                                inv_B,
                                C_in,
                                set_en,
                                btr;
        output  reg     [1:0]   set_typ,
                                branch_typ;
        output  reg     [2:0]   ALU_op;
    
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

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
	//None

/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/
	always @(*) begin
        //Default signal declarations
        imm_rt_sel  = 1'b0;
        LBI	     = 1'b0;
        SLBI        = 1'b0;
        branch_en   = 1'b0;
        sign        = 1'b0;
        inv_A       = 1'b0;
        inv_B       = 1'b0;
        C_in        = 1'b0;
        set_en      = 1'b0;
        btr         = 1'b0;
        set_typ     = 2'b00;
        branch_typ  = 2'b00;
        ALU_op      = 3'b000;

        case(ALU_fn) 
            ALU_ADDI : begin
                imm_rt_sel  = 1'b1;
                sign        = 1'b1;
            end                    

            ALU_SUBI : begin
                imm_rt_sel  = 1'b1;
                sign        = 1'b1;
                inv_A       = 1'b1;
                C_in        = 1'b1;
            end      

            ALU_XORI : begin
                imm_rt_sel  = 1'b1;
                ALU_op      = 3'b010;
            end
            
            ALU_ANDNI : begin
                imm_rt_sel  = 1'b1;
                inv_B	     = 1'b1;
                ALU_op      = 3'b011;
            end

            ALU_ROLI : begin
                imm_rt_sel  = 1'b1;
                ALU_op      = 3'b100;
            end

            ALU_SLLI : begin
                imm_rt_sel  = 1'b1;
                ALU_op      = 3'b101;
            end

            ALU_RORI : begin
                imm_rt_sel  = 1'b1;
                ALU_op      = 3'b110;
            end

            ALU_SRLI : begin
                imm_rt_sel  = 1'b1;
                ALU_op      = 3'b111;
            end

            ALU_BTR : begin
                btr = 1'b1;
            end

            ALU_ADD : begin
                sign = 1'b1;
            end

            ALU_SUB : begin
                sign  = 1'b1;
                inv_A = 1'b1;
                C_in  = 1'b1;
            end

            ALU_XOR : begin
                ALU_op = 3'b010;
            end

            ALU_ANDN : begin
                ALU_op = 3'b011;
                inv_B  = 1'b1;
            end

            ALU_ROL : begin
                ALU_op = 3'b100;
            end

            ALU_SLL : begin
                ALU_op = 3'b101;
            end
            
            ALU_ROR : begin
                ALU_op = 3'b110;
            end
            
            ALU_SRL : begin
                ALU_op = 3'b111;
            end

            ALU_SEQ	 : begin
                sign    = 1'b1;
                inv_B   = 1'b1;
                C_in    = 1'b1;
                set_en  = 1'b1;
                set_typ = 2'b00;
            end

            ALU_SLT : begin
                sign    = 1'b1;
                inv_B   = 1'b1;
                C_in    = 1'b1;
                set_en  = 1'b1;
                set_typ = 2'b01;
            end

            ALU_SLE : begin
                sign    = 1'b1;
                inv_B   = 1'b1;
                C_in    = 1'b1;
                set_en  = 1'b1;
                set_typ = 2'b10;
            end

            ALU_SCO : begin
                // sign    = 1'b1;
                // inv_B   = 1'b1;
                // C_in    = 1'b1;
                set_en  = 1'b1;
                set_typ = 2'b11;
            end

            ALU_BEQZ : begin
                sign      = 1'b1;
                branch_en = 1'b1;
                branch_typ= 2'b00;
            end 

            ALU_BNEZ : begin
                sign      = 1'b1;
                branch_en = 1'b1;
                branch_typ= 2'b01;
            end 

            ALU_BLTZ : begin
                sign      = 1'b1;
                branch_en = 1'b1;
                branch_typ= 2'b10;
            end 

            ALU_BGEZ : begin
                sign      = 1'b1;
                branch_en = 1'b1;
                branch_typ= 2'b11;
            end 
            
            ALU_LBI : begin
                imm_rt_sel = 1'b1;
                LBI        = 1'b1;
                sign       = 1'b1;
            end

            ALU_SLBI : begin
                imm_rt_sel = 1'b1;
                SLBI 	    = 1'b1;
                ALU_op     = 3'b001;
            end

            ALU_J : begin
                sign = 1'b1;
            end

            ALU_JR : begin
                imm_rt_sel = 1'b1;
                sign       = 1'b1;
            end     

            default : begin
                imm_rt_sel  = 1'b0;
                SLBI        = 1'b0;
                branch_en   = 1'b0;
                sign        = 1'b0;
                inv_A       = 1'b0;
                inv_B       = 1'b0;
                C_in        = 1'b0;
                set_en      = 1'b0;
                btr         = 1'b0;
                set_typ     = 2'b00;
                branch_typ  = 2'b00;
                ALU_op      = 3'b000;
                //Put error signal here
            end
        endcase
    end
endmodule
