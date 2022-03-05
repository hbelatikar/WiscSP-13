//////////////////////////////////////////////
// Project      : WiscSP13 - Unpipelined    //
// Module       : EX_top                    //
// Descrption   : Execute block of proc     //
// Author       : Hrishikesh Belatikar      //
// Date         : November 5th 2021         //
//////////////////////////////////////////////

module EX_top   (read_reg_1, read_reg_2, imm_16bit, PC2, EX_MEM_fwd_data, write_back, 
                 JAL_JALR, forward_A, forward_B, ALU_fn, EX_out, branch_sel);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input CLK & RST
		//None

    //Input Signals
        input wire [15:0]   read_reg_1,
                            read_reg_2,
                            imm_16bit,
                            EX_MEM_fwd_data,
                            write_back,
                            PC2;
    //Input Control Signals
        input wire [4:0]    ALU_fn;

        input wire [1:0]    forward_A,
                            forward_B;
        
        input wire          JAL_JALR;
    
    //Output Signals
        output wire branch_sel;
        output wire [15:0]  EX_out;

/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
	//Declare the control signals and other stuff here
    //ALU output paths
    wire    [15:0]  ALU_out,
                    ALU_out_set,
                    ALU_out_set_rev;
    
    //ALU input paths
    wire    [15:0]  ALU_A,
                    A_ip_shifted,
                    A_data_reg_shfted,
                    A_data_reg_shfted_none,
                    A_frwrd_data,
                    ALU_B,
                    B_data_reg_imm,
                    B_data_reg_imm_zero,
                    B_frwrd_data;
    
    wire            ALU_neg,
                    ALU_zero,
                    ALU_ofl;  
    
    //ALU Control paths
    wire            imm_rt_sel,
                    SLBI,
                    branch_en,
                    sign,
                    inv_A,
                    inv_B,
                    C_in,
                    set_en,
                    btr;
    wire    [1:0]   set_typ,
                    branch_typ;
    wire    [2:0]   ALU_op;

    //Instantiated Block outputs
    wire    [15:0]  set_out,
                    ip_reversed;
                    
/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/

    alu             ALU0   (.A(ALU_A), .B(ALU_B), .Cin(C_in), .Op(ALU_op), .Out(ALU_out), .invA(inv_A),
                            .invB(inv_B), .sign(sign), .Ofl(ALU_ofl), .neg(ALU_neg), .Z(ALU_zero));

    set_checker     STC0   (.zero(ALU_zero), .neg(ALU_neg), .ofl(ALU_ofl),
                            .set_typ(set_typ), .set_out(set_out));
    
    brnch_checker   BRC0   (.zero(ALU_zero), .neg(ALU_neg),
                            .branch_typ(branch_typ), .branch_sel(branch_sel));
                        
    ALU_control     ALUC0  (.ALU_fn(ALU_fn), .imm_rt_sel(imm_rt_sel), .SLBI(SLBI), .LBI(LBI),
                            .branch_en(branch_en), .ALU_op(ALU_op), .sign(sign), 
                            .inv_A(inv_A), .inv_B(inv_B), .C_in(C_in), .set_typ(set_typ),
                            .set_en(set_en), .branch_typ(branch_typ), .btr(btr));

    mux_4_1_16bit   FWDMA0 (.in0(read_reg_1), .in1(write_back), .in2(EX_MEM_fwd_data), .in3(16'b0), .sel(forward_A), .out0(A_frwrd_data));
    mux_4_1_16bit   FWDMB0 (.in0(read_reg_2), .in1(write_back), .in2(EX_MEM_fwd_data), .in3(16'b0), .sel(forward_B), .out0(B_frwrd_data));

/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/
	//Muxes which change ALU input values
    assign A_data_reg_shfted      = SLBI   ?   A_ip_shifted : A_frwrd_data;
    assign A_data_reg_shfted_none = LBI    ?   16'h0000     : A_data_reg_shfted;
    assign ALU_A                  = A_data_reg_shfted_none;

    assign B_data_reg_imm      = imm_rt_sel ? imm_16bit : B_frwrd_data;
    assign B_data_reg_imm_zero = branch_en  ? 16'h0000  : B_data_reg_imm;
    assign ALU_B               = B_data_reg_imm_zero;
    
    //Muxes which change ALU output values
    assign ALU_out_set  = set_en ? set_out     : ALU_out;
    assign ALU_out_set_rev = btr    ? ip_reversed : ALU_out_set;
    assign EX_out       = JAL_JALR ? PC2 : ALU_out_set_rev;

    //Bit changing logic
    assign A_ip_shifted  = { A_frwrd_data[7:0] , {8{1'b0}} };
    assign ip_reversed = { A_frwrd_data[0], A_frwrd_data[1], A_frwrd_data[2], A_frwrd_data[3], 
    			    A_frwrd_data[4], A_frwrd_data[5], A_frwrd_data[6], A_frwrd_data[7], 
    			    A_frwrd_data[8], A_frwrd_data[9], A_frwrd_data[10], A_frwrd_data[11], 
    			    A_frwrd_data[12], A_frwrd_data[13], A_frwrd_data[14], A_frwrd_data[15] };

endmodule
