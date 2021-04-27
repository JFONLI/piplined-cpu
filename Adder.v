module Adder(
    src1_i,
	src2_i,
	sum_o
	);
     
//I/O ports
input  [64-1:0]  src1_i;
input  [64-1:0]	 src2_i;
output [64-1:0]	 sum_o;

//Internal Signals
wire    [64-1:0]	 sum_o;

//Parameter
    
//Main function
	assign sum_o = src1_i + src2_i;

endmodule