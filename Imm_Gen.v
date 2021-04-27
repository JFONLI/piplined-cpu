module Imm_Gen(
    data_i,
    data_o
    );

//I/O ports
input   [32-1:0] data_i;
output  [64-1:0] data_o;

//Internal Signals
reg     [64-1:0] data_o;

//Gen Imm
always @* begin
	if((data_i[6:0] == 7'b0010011) || (data_i[6:0] == 7'b0000011)) data_o = {{52{data_i[31]}},data_i[31:20]};
	else if (data_i[6:0] == 7'b0100011) data_o = {{52{data_i[31]}},data_i[31:25],data_i[11:7]};
    else if (data_i[6:0] == 7'b1100011) data_o = {{52{data_i[31]}},{data_i[31],data_i[7],data_i[30:25],data_i[11:8]}};
    else data_o = {{32{data_i[31]}},data_i};
end

endmodule