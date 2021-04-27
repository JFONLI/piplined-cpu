module Shift_Left_One_64(
    data_i,
    data_o
    );

//I/O ports                    
input [64-1:0] data_i;
output [64-1:0] data_o;

//shift left 1
assign data_o = data_i << 1;
		
endmodule