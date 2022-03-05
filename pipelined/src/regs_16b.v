  
module regs_16b (clk, rst, in_data, out_data, en);
    input clk, rst, en;
    input [15:0] in_data;
    output [15:0] out_data;
    
    wire [15:0] wrt_data;

    assign wrt_data = en ? in_data : out_data;

    dff U0 [15:0] (.d(wrt_data), .q(out_data), .clk(clk), .rst(rst));

endmodule
