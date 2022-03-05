//////////////////////////////////////////////
// Project      : WiscSP13 - Unpipelined    //
// Module       : extender_block            //
// Description  : Extends 8 bit to 16 bit   //
// Author       : Hrishikesh Belatikar      //
// Date         : November 5th 2021         //
//////////////////////////////////////////////

module extender_block (data_in, extended_data, imm_len, imm_sign);
    
/*****************************************************|
|********* Input/ Output Signal Declarations *********|
|*****************************************************/
    //Input Clock & Reset
    //None

    //Input Signals
    input wire [7:0]   data_in;
    
    //Input Control Signals
    input wire  imm_len,
                imm_sign; 
    
    //Output Signals
    output wire [15:0] extended_data;

/*****************************************************|
|********* Internal Module Instantitations ***********|
|*****************************************************/
    //None

/*****************************************************|
|********** Internal Signal Declarations *************|
|*****************************************************/
    wire [15:0] zero_extend_8_16,
                sign_extend_8_16,
                zero_extend_5_16,
                sign_extend_5_16,
                extend_5_16,
                extend_8_16;

/*****************************************************|
|***************** Internal Logic ********************|
|*****************************************************/

    assign zero_extend_8_16 = { {8{1'b0}}        ,  data_in     };
    assign sign_extend_8_16 = { {8{data_in[7]}}  ,  data_in     };
    assign zero_extend_5_16 = { {11{1'b0}}       ,  data_in[4:0]};
    assign sign_extend_5_16 = { {11{data_in[4]}} ,  data_in[4:0]};

    assign extend_5_16 = imm_sign ? sign_extend_5_16 : zero_extend_5_16 ;
    assign extend_8_16 = imm_sign ? sign_extend_8_16 : zero_extend_8_16 ;

    assign extended_data = imm_len ? extend_5_16 : extend_8_16;

endmodule
