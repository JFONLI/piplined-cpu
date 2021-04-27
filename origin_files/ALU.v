module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  [64-1:0]  src1_i;
input  [64-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [64-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [64-1:0]  result_o;
wire             zero_o;

//Parameter

//Main function
endmodule