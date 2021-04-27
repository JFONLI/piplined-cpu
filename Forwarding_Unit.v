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
	ForwardA = 2'b00;
	ForwardB = 2'b00;

	if (EX_MEMRegWrite == 1 && (EX_MEMRegisterRd != 0) && (EX_MEMRegisterRd == ID_EXRegisterRs1))begin
		ForwardA = 2'b10;
	end
	if (EX_MEMRegWrite == 1 && (EX_MEMRegisterRd != 0) && (EX_MEMRegisterRd == ID_EXRegisterRs2))begin
		ForwardB = 2'b10;
	end
	if (MEM_WBRegWrite == 1 && (MEM_WBRegisterRd != 0) && !(EX_MEMRegWrite == 1 && (EX_MEMRegisterRd != 0) && (EX_MEMRegisterRd == ID_EXRegisterRs1)) && (MEM_WBRegisterRd == ID_EXRegisterRs1))begin
		ForwardA = 2'b01;
	end
	if (MEM_WBRegWrite == 1 && (MEM_WBRegisterRd != 0) && !(EX_MEMRegWrite == 1 && (EX_MEMRegisterRd != 0) && (EX_MEMRegisterRd == ID_EXRegisterRs2)) && (MEM_WBRegisterRd == ID_EXRegisterRs2))begin
		ForwardB = 2'b01;
	end
end


endmodule
