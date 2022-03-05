
module decoder_3to8 (in,out,err);
    input [2:0] in;
    output reg [7:0] out;
    output reg err;
    always @(*) begin
        case (in)
            3'b000: begin err = 1'b0; out=8'b0000_0001; end
            3'b001: begin err = 1'b0; out=8'b0000_0010; end
            3'b010: begin err = 1'b0; out=8'b0000_0100; end
            3'b011: begin err = 1'b0; out=8'b0000_1000; end
            3'b100: begin err = 1'b0; out=8'b0001_0000; end
            3'b101: begin err = 1'b0; out=8'b0010_0000; end
            3'b110: begin err = 1'b0; out=8'b0100_0000; end
            3'b111: begin err = 1'b0; out=8'b1000_0000; end
            default:begin err = 1'b1; out=8'b0000_0000; end
        endcase 
    end
endmodule