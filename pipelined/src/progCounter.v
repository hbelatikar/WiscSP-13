//////////////////////////////////////////////
// Project      : WiscSP13 - Unpipelined    //
// Module       : progCounter               //
// Descrption   : Store program counter     //
// Author       : Hrishikesh Belatikar      //
// Date         : November 5th 2021         //
//////////////////////////////////////////////

module progCounter (clk, rst, nxt_addr, curr_addr);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input CLK & RST
    input wire  clk,
                rst;

    //Input Signals
    input wire [15:0] nxt_addr;
    
    //Input Control Signals
    ////None
    
    //Output Signals
    output wire [15:0]  curr_addr;

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
    dff D1  (.d(nxt_addr[0]),  .q(curr_addr[0]),  .clk(clk), .rst(rst));
	dff D2  (.d(nxt_addr[1]),  .q(curr_addr[1]),  .clk(clk), .rst(rst));
	dff D3  (.d(nxt_addr[2]),  .q(curr_addr[2]),  .clk(clk), .rst(rst));
	dff D4  (.d(nxt_addr[3]),  .q(curr_addr[3]),  .clk(clk), .rst(rst));
	dff D5  (.d(nxt_addr[4]),  .q(curr_addr[4]),  .clk(clk), .rst(rst));
	dff D6  (.d(nxt_addr[5]),  .q(curr_addr[5]),  .clk(clk), .rst(rst));
	dff D7  (.d(nxt_addr[6]),  .q(curr_addr[6]),  .clk(clk), .rst(rst));
	dff D8  (.d(nxt_addr[7]),  .q(curr_addr[7]),  .clk(clk), .rst(rst));
	dff D9  (.d(nxt_addr[8]),  .q(curr_addr[8]),  .clk(clk), .rst(rst));
	dff D10 (.d(nxt_addr[9]),  .q(curr_addr[9]),  .clk(clk), .rst(rst));
	dff D11 (.d(nxt_addr[10]), .q(curr_addr[10]), .clk(clk), .rst(rst));
	dff D12 (.d(nxt_addr[11]), .q(curr_addr[11]), .clk(clk), .rst(rst));
	dff D13 (.d(nxt_addr[12]), .q(curr_addr[12]), .clk(clk), .rst(rst));
	dff D14 (.d(nxt_addr[13]), .q(curr_addr[13]), .clk(clk), .rst(rst));
	dff D15 (.d(nxt_addr[14]), .q(curr_addr[14]), .clk(clk), .rst(rst));
	dff D16 (.d(nxt_addr[15]), .q(curr_addr[15]), .clk(clk), .rst(rst));

endmodule
