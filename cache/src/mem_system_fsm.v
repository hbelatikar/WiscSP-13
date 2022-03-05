module mem_system_fsm (
    
    ///////////////////////
    ////// OUTPUTS ///////
    /////////////////////
    
    //FSM Outputs to mem_system outputs
    ms_Done, ms_Stall, ms_DataOut, ms_CacheHit,
    
    //FSM Outputs to cache input 
    c_en, c_comp, c_wr, c_valid_in, 
    c_tag_in, c_index, c_offset, c_data_in,
    
    //FSM Outputs to mem input 
    m_rd, m_wr, m_data_in, m_addr,

    //////////////////////
    ////// INPUTS ///////
    ////////////////////
    
    //FSM Inputs from mem_system inputs
    ms_Addr, ms_DataIn, ms_rd, ms_wr, 
    
    //FSM Inputs from cache outputs
    c_hit, c_dirty, c_valid_out, c_tag_out,
    c_data_out,
    
    //FSM Inputs from mem outputs
    m_stall, m_busy, m_data_out,
    
    //Clks & Rst
    clk, rst
);
    ///OUTPUT DEFINITIONS/////

    output  [15:0]  ms_DataOut;
    output  reg ms_Done,
                ms_Stall,
                ms_CacheHit;

    output reg  c_en,
                c_comp,
                c_wr,
                c_valid_in;
    output reg [4:0] c_tag_in;
    output reg [7:0] c_index;
    output reg [2:0] c_offset;
    output reg [15:0] c_data_in;

    output reg  m_rd,
                m_wr;
    output reg [15:0] m_data_in, m_addr;


    ///INPUT DEFINITIONS/////

    input [15:0] ms_Addr, ms_DataIn;
    input   ms_rd,
            ms_wr;

    input   c_hit,
            c_dirty,
            c_valid_out,
            c_valid_out;
    input [15:0] c_data_out;
    input [4:0]  c_tag_out;
 
    input m_stall;
    input [3:0] m_busy;
    input [15:0] m_data_out;

    input   clk , rst;

    //// STATE DECLARATIONS ////
    localparam  IDLE     = 3'h0,
                CMP_TAGS = 3'h1,
                WRTBCK   = 3'h2,
                ALOCTE   = 3'h3,
                ALOCTE2  = 3'h4;
                
    //// Internal logic declarations ///////
    wire [3:0] state;
    reg  [3:0] nxt_state;
    wire c_cout, m_cout;
    
    // Register to hold dataout value before completion of Allocate
    wire [15:0] stored_data;
    reg  [15:0] expected_data;
    reg  skip_store;
    //Store new data from memory into the flops?
    dff MSMDATA [15:0] (.d(expected_data), .q(stored_data), .clk(clk), .rst(rst));

    //Skip storing 
    assign ms_DataOut = skip_store ? expected_data : stored_data;

    //Counter register for the cache offset value
    reg c_inc_off;
    wire [1:0] c_offset_cntr_in, c_offset_cntr, c_off_incremented;
    dff COFSTCNTR [1:0] (.d(c_offset_cntr_in), .q(c_offset_cntr), .clk(clk), .rst(rst));
    assign c_offset_cntr_in = (c_inc_off) ? c_off_incremented : c_offset_cntr ;
    fulladder2 ADDC (.A(c_offset_cntr), .B(2'b01), .Cin(1'b0), .S(c_off_incremented), .Cout(c_cout)); 

    //Counter register for the main memory offset value
    reg m_inc_off;
    wire [1:0] m_offset_cntr_in, m_offset_cntr, m_off_incremented;
    dff MOFSTCNTR [1:0] (.d(m_offset_cntr_in), .q(m_offset_cntr), .clk(clk), .rst(rst));
    assign m_offset_cntr_in = (m_inc_off) ? m_off_incremented : m_offset_cntr ;
    fulladder2 ADDM (.A(m_offset_cntr), .B(2'b01), .Cin(1'b0), .S(m_off_incremented), .Cout(m_cout)); 

    //Delay wr & rd reqs for using in done=1 state
    wire ms_wr_ff,ms_rd_ff;
    dff WR_FF (.d(ms_wr), .q(ms_wr_ff), .clk(clk), .rst(rst));
    dff RD_FF (.d(ms_rd), .q(ms_rd_ff), .clk(clk), .rst(rst));

    // Instantiating Registers to hold state
    dff STATE_REGS [3:0] (.q(state), .d(nxt_state), .clk(clk), .rst(rst));

    always @(*) begin
        
        nxt_state   = state;
        //Mem_system sigs
        ms_Done     = 1'b0;
        ms_Stall    = 1'b1;
        ms_CacheHit = 1'b0;
        //Cache sigs
        c_valid_in  = 1'b0;
        c_en        = 1'b0;
        c_comp      = 1'b0;
        c_wr        = 1'b0;
        c_tag_in    = ms_Addr[15:11];
        c_index     = ms_Addr[10:3];
        c_offset    = ms_Addr[2:0];
        c_data_in   = 16'hXXXX;
        c_inc_off   = 1'b0;
        //Main Memory sigs
        m_rd        = 1'b0;
        m_wr        = 1'b0;
        m_data_in   = 16'hXXXX;
        m_addr      = 16'hXXXX;
        m_inc_off   = 1'b0;
        
        //Output data selc sigs
        expected_data = 16'hXXXX;
        skip_store = 1'b0;

        case (state)
            default: begin
                
                // Output control signals
                ms_Stall    = 1'b0;

                // Next state logic
                nxt_state = (ms_rd | ms_wr) ? CMP_TAGS :
                            state;
            end 

            CMP_TAGS : begin
                
                // Output control signals
                c_en    = 1'b1;
                c_comp  = 1'b1;
                c_wr    = ms_wr_ff;
                
                //Since data is ready already present it as output
                skip_store = 1'b1;
                expected_data = c_data_out;
                
                //If it was a write req  data would have been written here
                c_data_in = ms_DataIn;

                //Indicate done if these are the outputs
                ms_Done = (c_hit & c_valid_out);                
                ms_CacheHit = (c_hit & c_valid_out);

                // Next state logic
                nxt_state = (c_hit & c_valid_out)            ? IDLE   :
                            (~c_hit & c_valid_out & c_dirty) ? WRTBCK : 
                                                               ALOCTE ;
            end
    
            WRTBCK : begin
                
                // Output control signals
                // Cache control sigs
                c_en = 1'b1;
                c_inc_off = 1'b1;
                c_offset = {c_offset_cntr, 1'b0};

                // Main memory control sigs
                m_wr = 1'b1;
                m_inc_off = 1'b1;
                m_addr = {c_tag_out, ms_Addr[10:3], m_offset_cntr, 1'b0};
                m_data_in = c_data_out;

                // Next state logic
                nxt_state = (c_offset_cntr == 2'b11) ? ALOCTE : WRTBCK;

            end

            ALOCTE : begin
            //Only stimulate main memory since data is ready after 2 cycles
                
                // Output control signals
                //Main Memory Control sigs
                m_inc_off   = 1'b1;   
                m_rd        = 1'b1;
                m_addr      = {ms_Addr[15:3], m_offset_cntr, 1'b0};

                // Next state logic
                nxt_state   = (m_offset_cntr == 2'b01) ? ALOCTE2 : ALOCTE;
            end

            ALOCTE2 : begin
            //Data is now ready so start storing it in cache

                // Output control signals
                //Cache Control sigs
                c_en        = 1'b1;
                c_comp      = (ms_wr_ff & (c_offset_cntr == 2'b11));
                c_wr        = 1'b1;
                c_valid_in  = 1'b1;
                c_inc_off   = 1'b1;
                c_offset    = {c_offset_cntr, 1'b0};
                c_data_in   = (ms_wr_ff & (ms_Addr[2:1] == c_offset_cntr)) ? ms_DataIn : m_data_out;

                //Main memory Control sigs
                m_inc_off   = (m_offset_cntr[1]);
                m_rd        = (m_offset_cntr[1]);
                m_addr      = {ms_Addr[15:3], m_offset_cntr, 1'b0};

                //Output data control sigs
                expected_data = (ms_rd_ff & (ms_Addr[2:1] == c_offset_cntr)) ? m_data_out : stored_data;
                skip_store    = (c_offset_cntr == 2'b11);
                
                //Indicate done 
                ms_Done = (c_offset_cntr == 2'b11);

                // Next state logic
                nxt_state   = ((c_offset_cntr == 2'b11) & (ms_wr_ff | ms_rd_ff)) ? IDLE : ALOCTE2 ;
            end
        endcase
    end
endmodule