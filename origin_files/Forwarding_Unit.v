`timescale 1ns / 1ps
module Forwarding_Unit(
	EX_MEMRegWrite,
	MEM_WBRegWrite,
	EX_MEMRegisterRd,
	MEM_WBRegisterRd,
	ID_EXRegisterRs1,
	ID_EXRegisterRs2,
	ForwardA,
	ForwardB
	);
input EX_MEMRegWrite, MEM_WBRegWrite;
input [4:0] EX_MEMRegisterRd, MEM_WBRegisterRd, ID_EXRegisterRs1, ID_EXRegisterRs2;
output reg [1:0] ForwardA, ForwardB;

always@(*)begin
// add your code here

end


endmodule
