//////////////////////////////////////////////////
// Project      : WiscSP13 - Pipelined          //
// Module       : hazard_block                  //
// Descrption   : Detects and stall for hazards //
// Author       : Hrishikesh Belatikar          //
// Date         : November 29th 2021            //
//////////////////////////////////////////////////

module hazard_block (EX_mem_read, EX_rt_addr, ID_rs_addr, ID_rt_addr, MEM_mem_read,
                     MEM_mem_write, ID_mem_write, ID_mem_read, EX_mem_write, MEM_rt_addr,
                     ID_op_code, stall);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input CLK & RST
		//None

    //Input Signals
        input   EX_mem_read,    // ID/EX.MemRead
                EX_mem_write,
                MEM_mem_read,
                MEM_mem_write,
                ID_mem_read,
                ID_mem_write;
        
        input   [2:0]   EX_rt_addr,     // ID/EX.RegRt
                        ID_rs_addr,     // IF/ID.RegRs
                        ID_rt_addr,     // IF/ID.RegRt
                        MEM_rt_addr;

        
        input   [4:0]   ID_op_code;

    //Input Control Signals
    
    //Output Signals
        output stall;
/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
	//None

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
	//None

/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/
	/* Load Hazard
    if (ID/EX.MemRead and 
        ((ID/EX.RegisterRt = IF/ID.RegisterRs) or (ID/EX.RegisterRt = IF/ID.RegisterRt))
        )
        stall the pipeline
    */

    assign ld_hzrd_stall = EX_mem_read & ((EX_rt_addr == ID_rs_addr) | (EX_rt_addr == ID_rt_addr));
    //assign test_stall = ID_mem_read | ID_mem_write;
    // assign test_stall = EX_mem_read | EX_mem_write;
    // assign stall = ld_hzrd_stall | test_stall;    

    assign ld_hzrd_stall_2 = MEM_mem_read & ((MEM_rt_addr == ID_rs_addr) | (MEM_rt_addr == ID_rt_addr));
    
    // assign mem_stall = EX_mem_read | MEM_mem_read | EX_mem_write | MEM_mem_write;

    assign stall = ld_hzrd_stall | ld_hzrd_stall_2;// | mem_stall;

endmodule
