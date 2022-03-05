//////////////////////////////////////////////
// Project      : WiscSP13 - Unpipelined    //
// Module       : ID_top                    //
// Description  : Decodes the instruction   //
// Author       : Hrishikesh Belatikar      //
// Date         : November 5th 2021         //
//////////////////////////////////////////////

module ID_top  (clk, rst, PC2, instr, write_back, 
                J_JAL_addr, imm_16bit, read_reg_1,
                read_reg_2, op_code, reg_instr_op, 
                rd_sel, reg_write, imm_sign, imm_len);

/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input Clock & Reset
    input wire  clk,
                rst;

    //Input Signals
    input wire [15:0]   PC2,
                        instr,
                        write_back;
    
    //Input Control Signals
    input wire  reg_write,
                imm_sign,
                imm_len; 

    input wire [1:0] rd_sel;
    
    //Output Signals
    output wire [15:0]  J_JAL_addr,
                        imm_16bit,
                        read_reg_1,
                        read_reg_2;

    output wire [4:0]   op_code;
    output wire [1:0]   reg_instr_op;


/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
    wire [15:0] J_extended_addr; 
    wire [10:0] J_unextended_addr;      //Jump addr extracted from Instr Instr [11:0]
    wire [7:0]  imm_data_unextended;   //Imm data extracted from Instr Instr[7:0]
    wire [2:0]  reg1_addr,              //Instr[10:8]
                reg2_addr,              //Instr[7:5]
                rd_regI_addr,           //Instr[4:2]
                rt_rd_immI_addr,        //Instr[7:5]
                writereg_addr;          //Selected by the 4:1 mux
    
    wire        err_rf, err_J_JAL_addr;

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
    rf              iREGF  (.read1data(read_reg_1), .read2data(read_reg_2), .read1regsel(reg1_addr), .read2regsel(reg2_addr),
                            .writeregsel(writereg_addr), .writedata(write_back), .write(reg_write),
                            .err(err_rf), .clk(clk), .rst(rst));
    
    extender_block  iXTND  (.data_in(imm_data_unextended), .extended_data(imm_16bit), 
                            .imm_len(imm_len), .imm_sign(imm_sign));

    mux_4_1_3bit    iMUX0  (.in0(reg2_addr), .in1(rd_regI_addr), .in2(reg1_addr), 
                            .in3(3'b111), .sel(rd_sel), .out0(writereg_addr));
    
/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/

    assign op_code  = instr[15:11] ;
    assign reg_instr_op = instr[1:0];
    
    assign J_unextended_addr = instr[10:0];
    assign imm_data_unextended = instr[7:0];
    assign reg1_addr = instr[10:8];
    assign reg2_addr = instr[7:5];
    assign rd_regI_addr = instr[4:2];

    assign J_extended_addr = { {5{J_unextended_addr[10]}} ,  J_unextended_addr };
    assign {err_J_JAL_addr, J_JAL_addr} = J_extended_addr + PC2;

endmodule
