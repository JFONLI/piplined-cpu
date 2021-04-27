module Reg_File(
    clk_i,
	rst_i,
    RS1addr_i,
    RS2addr_i,
    RDaddr_i,
    RDdata_i,
    RegWrite_i,
    RS1data_o,
    RS2data_o
    );

//I/O ports
input           clk_i;
input           rst_i;
input           RegWrite_i;
input  [5-1:0]  RS1addr_i;
input  [5-1:0]  RS2addr_i;
input  [5-1:0]  RDaddr_i;
input  [64-1:0] RDdata_i;

output [64-1:0] RS1data_o;
output [64-1:0] RS2data_o;

//Internal signals/registers
reg  signed [64-1:0] Reg_File [0:32-1];     //32 dword registers
wire        [64-1:0] RS1data_o;
wire        [64-1:0] RS2data_o;

//Read the data
assign RS1data_o = Reg_File[RS1addr_i] ;
assign RS2data_o = Reg_File[RS2addr_i] ;

//Writing data when negative edge clk_i and RegWrite_i was set.
/*DO NOT CHANGE INITIAL VALUE*/
always @( negedge rst_i or negedge clk_i  ) begin
    if(rst_i == 0) begin
	    Reg_File[0]  <= 0; Reg_File[1]  <= 0; Reg_File[2]  <= 0; Reg_File[3]  <= 0;
	    Reg_File[4]  <= 0; Reg_File[5]  <= 0; Reg_File[6]  <= 0; Reg_File[7]  <= 0;
        Reg_File[8]  <= 0; Reg_File[9]  <= 0; Reg_File[10] <= 0; Reg_File[11] <= 0;
	    Reg_File[12] <= 0; Reg_File[13] <= 0; Reg_File[14] <= 0; Reg_File[15] <= 0;
        Reg_File[16] <= 0; Reg_File[17] <= 0; Reg_File[18] <= 0; Reg_File[19] <= 0;
        Reg_File[20] <= 0; Reg_File[21] <= 0; Reg_File[22] <= 0; Reg_File[23] <= 0;
        Reg_File[24] <= 0; Reg_File[25] <= 0; Reg_File[26] <= 0; Reg_File[27] <= 0;
        Reg_File[28] <= 0; Reg_File[29] <= 0; Reg_File[30] <= 0; Reg_File[31] <= 0;
	end
    else begin
        if(RegWrite_i && RDaddr_i!=0)
            Reg_File[RDaddr_i] <= RDdata_i;
		else
		    Reg_File[RDaddr_i] <= Reg_File[RDaddr_i];
	end
end

endmodule
