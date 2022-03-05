////////////////////////////////////////////////////////
// Project      : WiscSP13 - Pipelined                //
// Module       : frwrd_block                         //
// Descrption   : Controls forwarding of ALU inputs   //
// Author       : Hrishikesh Belatikar                //
// Date         : November 29th 2021                  //
////////////////////////////////////////////////////////

module frwrd_block (EX_rs_addr, EX_rt_addr, EX_rd_addr, MEM_rd_addr, WB_rd_addr, branch,
					MEM_reg_write, WB_reg_write, ID_rt_addr, ID_mem_write, checker_fwd, 
					ID_rs_addr, skip_rf_Rs, skip_rf_Rt, forward_A, forward_B, storing_fwd,
					JR_JALR, EX_reg_write);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input CLK & RST
		//None

    //Input Signals
		
        input wire	[2:0]	EX_rs_addr,		// ID/EX.RegRs
                    		EX_rt_addr,		// ID/EX.RegRt
                    		EX_rd_addr,		// ID/EX.RegRd
                    		MEM_rd_addr,	// EX/MEM.RegRd
                    		WB_rd_addr,		// MEM/WB.RegRd
							ID_rs_addr,		// IF/ID.RegRs
							ID_rt_addr;		// IF/ID.RegRt
        
    //Input Control Signals
        input	wire	MEM_reg_write,	// EX/MEM.RegWrite
            			WB_reg_write,	// MEM/WB.RegWrite
						ID_mem_write,
						EX_reg_write,
						branch,
						JR_JALR;
        
    //Output Signals
        output wire	[1:0]	forward_A,	// Control sig to forward to A input of ALU 
        					forward_B,	// Control sig to forward to B input of ALU 
							storing_fwd,
							checker_fwd;
		
		output wire 		skip_rf_Rs,	// Control sign to bypass reg file writing for Rs
							skip_rf_Rt; // Control sign to bypass reg file writing for Rt	
    
/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
	wire	A_needs_EX_fwd, B_needs_EX_fwd, 
			A_needs_MEM_fwd, B_needs_MEM_fwd,
			A_needs_WB_fwd, B_needs_WB_fwd;

	wire	storing_needs_EX_fwd,
			storing_needs_MEM_fwd,
			storing_needs_bypass,
			checker_needs_EX_fwd,
			checker_needs_MEM_fwd,
			checker_needs_bypass;			

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
	//None

/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/
	//Register Forwarding
	assign skip_rf_Rs = WB_reg_write & (WB_rd_addr == ID_rs_addr);
	assign skip_rf_Rt = WB_reg_write & (WB_rd_addr == ID_rt_addr);

	//EX Forwarding
	/*
	if (EX/MEM.RegWrite AND (EX/MEM.RegisterRd ≠ 0) AND (EX/MEM.RegisterRd = ID/EX.RegisterRs)) 
		ForwardA = 10
	if (EX/MEM.RegWrite AND (EX/MEM.RegisterRd ≠ 0) AND (EX/MEM.RegisterRd = ID/EX.RegisterRt)) 
		ForwardB = 10
	*/

	assign 	A_needs_EX_fwd = MEM_reg_write & (MEM_rd_addr == EX_rs_addr);
	assign	B_needs_EX_fwd = MEM_reg_write & (MEM_rd_addr == EX_rt_addr);

	//MEM Forwarding
	/*
	if (MEM/WB.RegWrite AND 
			(MEM/WB.RegisterRd = ID/EX.RegisterRs)) AND 
				not(EX/MEM.RegWrite and (EX/MEM.RegisterRd ≠ 0)  and (EX/MEM.RegisterRd ≠ ID/EX.RegisterRs)) 
		ForwardA = 01
	if (
		MEM/WB.RegWrite AND
				(MEM/WB.RegisterRd = ID/EX.RegisterRt)) AND
					not(EX/MEM.RegWrite AND (EX/MEM.RegisterRd ≠ 0) and (EX/MEM.RegisterRd ≠ ID/EX.RegisterRt)) 
		ForwardB = 01
	*/
	assign 	A_needs_MEM_fwd = 	WB_reg_write & (WB_rd_addr == EX_rs_addr) & ~(MEM_reg_write & (MEM_rd_addr != EX_rs_addr));
	assign	B_needs_MEM_fwd = 	WB_reg_write & (WB_rd_addr == EX_rt_addr) & ~(MEM_reg_write & (MEM_rd_addr != EX_rt_addr));
	
	//WB Forwarding
	// assign 	A_needs_WB_fwd = MEM_reg_write & (WB_rd_addr == EX_rs_addr);
	// assign	B_needs_WB_fwd = MEM_reg_write & (WB_rd_addr == EX_rt_addr);
	assign 	A_needs_WB_fwd = WB_reg_write & (WB_rd_addr == EX_rs_addr);
	assign	B_needs_WB_fwd = WB_reg_write & (WB_rd_addr == EX_rt_addr);

	assign forward_A =	A_needs_EX_fwd 	? 2'b10 :
						(A_needs_MEM_fwd | A_needs_WB_fwd)? 2'b01 :
						2'b00;

	assign forward_B =	B_needs_EX_fwd 						? 2'b10 :
						(B_needs_MEM_fwd | B_needs_WB_fwd)  ? 2'b01 :
						2'b00;

	//Forwarding for proper storage during memory store operations	
	assign storing_needs_EX_fwd  = ID_mem_write & (ID_rt_addr == EX_rd_addr)  & EX_reg_write;
	assign storing_needs_MEM_fwd = ID_mem_write & (ID_rt_addr == MEM_rd_addr) & MEM_reg_write;
	assign storing_needs_bypass  = ID_mem_write & (ID_rt_addr == WB_rd_addr)  & WB_reg_write;

	assign storing_fwd = storing_needs_EX_fwd	? 2'b10	:
						 storing_needs_MEM_fwd	? 2'b01 :
						 storing_needs_bypass	? 2'b11	:
						 2'b00;	

	//Forwarding for proper value checks during early branching
	assign checker_needs_EX_fwd  = (branch | JR_JALR) & (ID_rs_addr == EX_rd_addr) 	& EX_reg_write;
	assign checker_needs_MEM_fwd = (branch | JR_JALR) & (ID_rs_addr == MEM_rd_addr) & MEM_reg_write;
	assign checker_needs_bypass  = (branch | JR_JALR) & (ID_rs_addr == WB_rd_addr)  & WB_reg_write;

	assign checker_fwd = checker_needs_EX_fwd	? 2'b10	:
						 checker_needs_MEM_fwd	? 2'b01 :
						 checker_needs_bypass	? 2'b11	:
						 2'b00;	

endmodule
