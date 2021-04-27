module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  signed [64-1:0]  src1_i;
input  signed [64-1:0]	src2_i;
input  [4-1:0]   ctrl_i;

output [64-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [64-1:0]  result_o;
wire             zero_o;

wire [64-1:0] src2_i_2scomplement;
wire [64-1:0] sub_result;

//Parameter
assign zero_o = (result_o == 0)? 1'b1:1'b0;

//Main function
always@(*) begin
	case(ctrl_i)
		4'b0000: result_o = src1_i & src2_i;
		4'b0001: result_o = src1_i | src2_i;
		4'b0010: result_o = src1_i + src2_i;
		4'b0110: result_o = src1_i - src2_i;	
		4'b0111: result_o = (src1_i < src2_i)?64'd1:64'd0;
		//4'b1111: result_o = (sub_result[63] == 1'b1)?1'b1:1'b0;
		4'b1100: result_o = ~(src1_i|src2_i);
		default: begin end
	endcase
end

	
	
endmodule