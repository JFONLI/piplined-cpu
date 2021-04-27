VLOG = ncverilog
WAV = +access+r
Test = Test_Bench.v
CPU = Pipe_CPU.v
Mem = Data_Mem.v Reg_File.v Pipe_Reg.v Instr_Mem.v
ALU = Adder.v ALU.v ALU_Ctrl.v Control.v MUX_2to1.v MUX_3to1.v Program_Counter.v Shift_Left_One_64.v Imm_Gen.v Forwarding_Unit.v
all:
	$(VLOG) $(CPU) $(Mem) $(ALU) $(Test) $(WAV)