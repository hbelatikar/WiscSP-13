/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
// Outputs
DataOut, Done, Stall, CacheHit, err,
// Inputs
Addr, DataIn, Rd, Wr, createdump, clk, rst
);

	input [15:0] Addr;
	input [15:0] DataIn;
	input        Rd;
	input        Wr;
	input        createdump;
	input        clk;
	input        rst;

	output [15:0] DataOut;
	output Done;
	output Stall;
	output CacheHit;
	output err;

	//Declaring internal logic
	wire c_err, c_hit, c_dirty, c_valid_out, c_en, c_comp, c_wr, c_valid_in;
	wire m_err, m_stall, m_wr, m_rd;
	wire [2:0] c_offset;
	wire [3:0] m_busy;
	wire [4:0] c_tag_in, c_tag_out;
	wire [7:0] c_index;
	wire [15:0] c_data_out, m_data_out, c_data_in, m_addr, m_data_in;

	/* data_mem = 1, inst_mem = 0 *
	* needed for cache parameter */
	parameter memtype = 0;
	cache #(0 + memtype) c0(
		// Outputs
			.tag_out              (c_tag_out),           
			.data_out             (c_data_out), 												
			.hit                  (c_hit),																	
			.dirty                (c_dirty),    																
			.valid                (c_valid_out),	
			.err                  (c_err),
			
			// Inputs
			.enable               (c_en),										
			.clk                  (clk),        
			.rst                  (rst),		
			.createdump           (createdump), 
			.tag_in               (c_tag_in),	
			.index                (c_index),           															
			.offset               (c_offset),
			.data_in              (c_data_in),	
			.comp                 (c_comp), 
			.write                (c_wr),       
			.valid_in             (c_valid_in));


	four_bank_mem mem(// Outputs
					.data_out          (m_data_out),  
					.stall             (m_stall),  					
					.busy              (m_busy),  
					.err               (m_err),
					
					// Inputs
					.clk               (clk),

					.rst               (rst),	
					.createdump        (createdump),

					.addr              (m_addr),		
					.data_in           (m_data_in),

					.wr                (m_wr),  
					.rd                (m_rd)); 

	// your code here
	//Instantiating the mem_system control FSM

	mem_system_fsm FSM1 (
    //Outputs
    .ms_Done(Done), .ms_Stall(Stall), .ms_DataOut(DataOut), .ms_CacheHit(CacheHit),
    
    //FSM Outputs to cache input 
    .c_en(c_en), .c_comp(c_comp), .c_wr(c_wr), .c_valid_in(c_valid_in), 
    .c_tag_in(c_tag_in), .c_index(c_index), .c_offset(c_offset), .c_data_in(c_data_in),
    
    //FSM Outputs to mem input 
    .m_rd(m_rd), .m_wr(m_wr), .m_data_in(m_data_in), .m_addr(m_addr),

    //////////////////////
    ////// INPUTS ///////
    ////////////////////
    
    //FSM Inputs from mem_system inputs
    .ms_Addr(Addr), .ms_DataIn(DataIn), .ms_rd(Rd), .ms_wr(Wr), 
    
    //FSM Inputs from cache outputs
    .c_hit(c_hit), .c_dirty(c_dirty), .c_valid_out(c_valid_out), .c_tag_out(c_tag_out),
    .c_data_out(c_data_out),
    
    //FSM Inputs from mem outputs
    .m_stall(m_stall), .m_busy(m_busy), .m_data_out(m_data_out),
	
	.clk(clk), .rst(rst));

	//Assigning error signal if there are errors in memory below
	assign err = m_err | c_err;

	
	endmodule // mem_system

	// DUMMY LINE FOR REV CONTROL :9:
