/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf (
           // Outputs
           read1data, read2data, err,
           // Inputs
           clk, rst, read1regsel, read2regsel, writeregsel, writedata, write
           );
    input clk, rst;
    input [2:0] read1regsel;
    input [2:0] read2regsel;
    input [2:0] writeregsel;
    input [15:0] writedata;
    input        write; 

    output [15:0] read1data;
    output [15:0] read2data;
    output        err;

    // your code
    
    // Defining wires for register output wire
    wire [7:0] decoded_write_reg,enabled_write_reg;
    wire [15:0] reg_read_data [0:7];
    
    // Instantiating the decoder
    decoder_3to8 DEC0 (.in(writeregsel), .out(decoded_write_reg), .err(err));
    assign enabled_write_reg = decoded_write_reg & {8{write}};
    // Instantiating 8 16bit registers
    
    regs_16b R0 (.clk(clk), .rst(rst), .in_data(writedata), .out_data(reg_read_data[0]), .en(enabled_write_reg[0]));
    regs_16b R1 (.clk(clk), .rst(rst), .in_data(writedata), .out_data(reg_read_data[1]), .en(enabled_write_reg[1]));
    regs_16b R2 (.clk(clk), .rst(rst), .in_data(writedata), .out_data(reg_read_data[2]), .en(enabled_write_reg[2]));
    regs_16b R3 (.clk(clk), .rst(rst), .in_data(writedata), .out_data(reg_read_data[3]), .en(enabled_write_reg[3]));
    regs_16b R4 (.clk(clk), .rst(rst), .in_data(writedata), .out_data(reg_read_data[4]), .en(enabled_write_reg[4]));
    regs_16b R5 (.clk(clk), .rst(rst), .in_data(writedata), .out_data(reg_read_data[5]), .en(enabled_write_reg[5]));
    regs_16b R6 (.clk(clk), .rst(rst), .in_data(writedata), .out_data(reg_read_data[6]), .en(enabled_write_reg[6]));
    regs_16b R7 (.clk(clk), .rst(rst), .in_data(writedata), .out_data(reg_read_data[7]), .en(enabled_write_reg[7]));

    // Mux reader reg
    assign read1data = reg_read_data[read1regsel];
    assign read2data = reg_read_data[read2regsel];

endmodule
// DUMMY LINE FOR REV CONTROL :1:
