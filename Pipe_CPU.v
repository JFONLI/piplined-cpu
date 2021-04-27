`timescale 1ns / 1ps
module Pipe_CPU(
        clk_i,
		rst_i
		);
    
/****************************************
*               I/O ports               *
****************************************/
input clk_i;
input rst_i;

/****************************************
*            Internal signal            *
****************************************/

/**** IF stage ****/
//control signal...
wire [32-1:0] instr_w;			//
wire [64-1:0] mux_pc_result_w;	//
wire [64-1:0] pc_addr_w;		//
wire [64-1:0] add1_source_w;	//
assign add1_source_w = 64'd4;	//
wire [64-1:0] add1_result_w;	//
wire and_result_w;				//

wire [64-1:0] IF_pc_addr_w;		//
wire [32-1:0] IF_instr_w;		//

/**** ID stage ****/
//control signal...
wire [64-1:0] rf_rs1_data_w;		//
wire [64-1:0] rf_rs2_data_w;		//
wire [64-1:0] mux_dataMem_result_w;	//
wire ctrl_branch_w;					//
wire ctrl_mem_read_w;				//
wire ctrl_mem_mux_w;				//		
wire [2-1:0]  ctrl_alu_op_w;		//
wire ctrl_mem_write_w;				//
wire ctrl_alu_mux_w;				//
wire ctrl_register_write_w;			//	
wire [64-1:0] Imm_Gen_w;			//

wire [5-1:0] MEM_Rd;				//
wire MEM_ctrl_register_write_w;		//

wire ID_ctrl_branch_w;				//
wire ID_ctrl_mem_read_w;			//
wire ID_ctrl_mem_mux_w;				//
wire [2-1:0] ID_ctrl_alu_op_w;		//
wire ID_ctrl_mem_write_w;			//
wire ID_ctrl_alu_mux_w;				//
wire ID_ctrl_register_write_w;		//
wire [64-1:0] ID_pc_addr_w;			//
wire [64-1:0] ID_rf_rs1_data_w;		//
wire [64-1:0] ID_rf_rs2_data_w;		//
wire [64-1:0] ID_Imm_Gen_w;			//
wire [4-1:0] funct_i_o;				//
wire [4-1:0] ID_funct_i_o;			//
wire [5-1:0] ID_Rs1;				//
wire [5-1:0] ID_Rs2;				//
wire [5-1:0] ID_Rd;					//

wire [64-1:0] alu_rs1_data;			//
wire [64-1:0] alu_rs2_data;			//
wire [4-1:0] alu_control_w;			//
wire [64-1:0] alu_result_w;			//
wire alu_zero_w;					//
wire [64-1:0] EX_alu_result_w;		//
wire [64-1:0] mux_2to1_src1;		//
wire [64-1:0] shift_left_w;			//
wire [64-1:0] add2_sum_w;			//



/**** EX stage ****/
//control signal...
wire EX_ctrl_branch_w;				//
wire EX_ctrl_mem_read_w;			//
wire EX_ctrl_mem_mux_w;				//
wire EX_ctrl_mem_write_w;			//
wire EX_ctrl_register_write_w;		//
wire [64-1:0] EX_add2_sum_w;		//
wire EX_alu_zero_w;					//
wire [64-1:0] EX_rf_rs2_data_w;		//
wire [5-1:0] EX_Rd;					//

wire [64-1:0] dataMem_read_w;		//

/**** MEM stage ****/
//control signal...
wire MEM_ctrl_mem_mux_w;			//
wire [64-1:0] MEM_alu_result_w;		//
wire [64-1:0] MEM_dataMem_read_w;	//


/**** WB stage ****/
//control signal...


/**** Data hazard ****/
//control signal...
wire [2-1:0] ForwardA;				//
wire [2-1:0] ForwardB;				//

Forwarding_Unit FU(
	.EX_MEMRegWrite(EX_ctrl_register_write_w),
	.MEM_WBRegWrite(MEM_ctrl_register_write_w),
	.EX_MEMRegisterRd(EX_Rd),
	.MEM_WBRegisterRd(MEM_Rd),
	.ID_EXRegisterRs1(ID_Rs1),
	.ID_EXRegisterRs2(ID_Rs2),
	.ForwardA(ForwardA),
	.ForwardB(ForwardB)
	);

/****************************************
*          Instantiate modules          *
****************************************/
//Instantiate the components in IF stage
Program_Counter PC(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.pc_in_i(mux_pc_result_w),
	.pc_out_o(pc_addr_w)
	);
		
MUX_2to1 #(.size(64)) Mux_PC_Source(
	.data0_i(add1_result_w),
    .data1_i(EX_add2_sum_w),
    .select_i(and_result_w),
    .data_o(mux_pc_result_w)
	);	

Instr_Mem IM(
	.pc_addr_i(pc_addr_w),
	.instr_o(instr_w)
	);
			
Adder Add_pc(
	.src1_i(add1_source_w),
	.src2_i(pc_addr_w),
	.sum_o(add1_result_w)
	);

//You need to instantiate many pipe_reg
Pipe_Reg #(.size(64)) IF_PC(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(pc_addr_w),
	.data_o(IF_pc_addr_w)
	);

Pipe_Reg #(.size(32)) IF_Instr_Mem(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(instr_w),
	.data_o(IF_instr_w)
	);
		
//Instantiate the components in ID stage
Reg_File RF(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.RS1addr_i(IF_instr_w[19:15]) ,
	.RS2addr_i(IF_instr_w[24:20]) ,
	.RDaddr_i(MEM_Rd) ,				
	.RDdata_i(mux_dataMem_result_w[64-1:0]),
	.RegWrite_i(MEM_ctrl_register_write_w),			
	.RS1data_o(rf_rs1_data_w) ,
	.RS2data_o(rf_rs2_data_w)
	);

Control Control(
	.instr_op_i(IF_instr_w[6:0]),
	.Branch_o(ctrl_branch_w),
	.MemRead_o(ctrl_mem_read_w),
	.MemtoReg_o(ctrl_mem_mux_w),
	.ALU_op_o(ctrl_alu_op_w),
	.MemWrite_o(ctrl_mem_write_w),
	.ALUSrc_o(ctrl_alu_mux_w),
	.RegWrite_o(ctrl_register_write_w)
	);

Imm_Gen IG(
	.data_i(IF_instr_w),
    .data_o(Imm_Gen_w)
	);	

//You need to instantiate many pipe_reg
Pipe_Reg #(.size(1)) ID_Branch(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(ctrl_branch_w),
	.data_o(ID_ctrl_branch_w)
	);

Pipe_Reg #(.size(1)) ID_MemRead(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(ctrl_mem_read_w),
	.data_o(ID_ctrl_mem_read_w)
	);

Pipe_Reg #(.size(1)) ID_MemtoReg(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(ctrl_mem_mux_w),
	.data_o(ID_ctrl_mem_mux_w)
	);
	
Pipe_Reg #(.size(2)) ID_ALUOp(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(ctrl_alu_op_w),
	.data_o(ID_ctrl_alu_op_w)
	);
	
Pipe_Reg #(.size(1)) ID_MemWrite(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(ctrl_mem_write_w),
	.data_o(ID_ctrl_mem_write_w)
	);
	
Pipe_Reg #(.size(1)) ID_ALUSrc(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(ctrl_alu_mux_w),
	.data_o(ID_ctrl_alu_mux_w)
	);

Pipe_Reg #(.size(1)) ID_RegWrite(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(ctrl_register_write_w),
	.data_o(ID_ctrl_register_write_w)
	);
	
Pipe_Reg #(.size(64)) ID_PC(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(IF_pc_addr_w),
	.data_o(ID_pc_addr_w)
	);
	
Pipe_Reg #(.size(64)) ID_ReadData1(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(rf_rs1_data_w),
	.data_o(ID_rf_rs1_data_w)
	);
	
Pipe_Reg #(.size(64)) ID_ReadData2(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(rf_rs2_data_w),
	.data_o(ID_rf_rs2_data_w)
	);
	
Pipe_Reg #(.size(64)) ID_ImmGen(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(Imm_Gen_w),
	.data_o(ID_Imm_Gen_w)
	);
	


Pipe_Reg #(.size(4)) ID_funct_i_o_G(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(funct_i_o),
	.data_o(ID_funct_i_o)
	);

Pipe_Reg #(.size(5)) ID_Rs1_Addr(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(IF_instr_w[19:15]),
	.data_o(ID_Rs1)
	);
	
Pipe_Reg #(.size(5)) ID_Rs2_Addr(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(IF_instr_w[24:20]),
	.data_o(ID_Rs2)
	);
	
Pipe_Reg #(.size(5)) ID_Rd_Addr(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(IF_instr_w[11:7]),
	.data_o(ID_Rd)
	);
	
//Instantiate the components in EX stage	   
ALU ALU(
	.src1_i(alu_rs1_data),
	.src2_i(alu_rs2_data),
	.ctrl_i(alu_control_w),
	.result_o(alu_result_w),
	.zero_o(alu_zero_w)
	);
		
MUX_3to1 #(.size(64)) Mux3_1_A(
	.data0_i(ID_rf_rs1_data_w),
    .data1_i(mux_dataMem_result_w),			
	.data2_i(EX_alu_result_w),								
    .select_i(ForwardA),
    .data_o(alu_rs1_data)
    );
		
MUX_3to1 #(.size(64)) Mux3_2_B(
	.data0_i(ID_rf_rs2_data_w),
    .data1_i(mux_dataMem_result_w),							
	.data2_i(EX_alu_result_w),								
    .select_i(ForwardB),
    .data_o(mux_2to1_src1)
    );
		
ALU_Ctrl AC(
	.funct_i(ID_funct_i_o),   
    .ALUOp_i(ID_ctrl_alu_op_w),   
    .ALUCtrl_o(alu_control_w) 
	);

MUX_2to1 #(.size(64)) Mux_ALUSrc(
	.data0_i(mux_2to1_src1),
    .data1_i(ID_Imm_Gen_w),
    .select_i(ID_ctrl_alu_mux_w),
    .data_o(alu_rs2_data)
    );
				
Shift_Left_One_64 Shifter(
	.data_i(ID_Imm_Gen_w),
    .data_o(shift_left_w)
	); 	
		
Adder Add_pc2(
	.src1_i(ID_pc_addr_w),     
	.src2_i(shift_left_w),     
	.sum_o(add2_sum_w) 
	);

//You need to instantiate many pipe_reg
Pipe_Reg #(.size(1)) EX_Branch(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(ID_ctrl_branch_w),
	.data_o(EX_ctrl_branch_w)
	);

Pipe_Reg #(.size(1)) EX_MemRead(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(ID_ctrl_mem_read_w),
	.data_o(EX_ctrl_mem_read_w)
	);

Pipe_Reg #(.size(1)) EX_MemtoReg(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(ID_ctrl_mem_mux_w),
	.data_o(EX_ctrl_mem_mux_w)
	);
	
Pipe_Reg #(.size(1)) EX_MemWrite(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(ID_ctrl_mem_write_w),
	.data_o(EX_ctrl_mem_write_w)
	);
	
Pipe_Reg #(.size(1)) EX_RegWrite(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(ID_ctrl_register_write_w),
	.data_o(EX_ctrl_register_write_w)
	);
	
Pipe_Reg #(.size(64)) EX_Add2(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(add2_sum_w),
	.data_o(EX_add2_sum_w)
	);
	
Pipe_Reg #(.size(1)) EX_Zero(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(alu_zero_w),
	.data_o(EX_alu_zero_w)
	);
	
Pipe_Reg #(.size(64)) EX_ALUResult(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(alu_result_w),
	.data_o(EX_alu_result_w)
	);

Pipe_Reg #(.size(64)) EX_ReadData2(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(ID_rf_rs2_data_w),
	.data_o(EX_rf_rs2_data_w)
	);	
	
Pipe_Reg #(.size(5)) EX_Rd_Addr(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(ID_Rd),
	.data_o(EX_Rd)
	);

//Instantiate the components in MEM stage


Data_Mem DM(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.addr_i(EX_alu_result_w),
	.data_i(EX_rf_rs2_data_w),
	.MemRead_i(EX_ctrl_mem_read_w),
	.MemWrite_i(EX_ctrl_mem_write_w),
	.data_o(dataMem_read_w)
	);

//You need to instantiate many pipe_reg
Pipe_Reg #(.size(1)) MEM_MemtoReg(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(EX_ctrl_mem_mux_w),
	.data_o(MEM_ctrl_mem_mux_w)
	);
	
Pipe_Reg #(.size(1)) MEM_RegWrite(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(EX_ctrl_register_write_w),
	.data_o(MEM_ctrl_register_write_w)
	);
	
Pipe_Reg #(.size(64)) MEM_ReadData(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(dataMem_read_w),
	.data_o(MEM_dataMem_read_w)
	);

Pipe_Reg #(.size(64)) MEM_ALUResult(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(EX_alu_result_w),
	.data_o(MEM_alu_result_w)
	);

Pipe_Reg #(.size(5)) MEM_Rd_Addr(
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_i(EX_Rd),
	.data_o(MEM_Rd)
	);

//Instantiate the components in WB stage
MUX_2to1 #(.size(64)) Mux2(
	.data0_i(MEM_alu_result_w),
	.data1_i(MEM_dataMem_read_w),
	.select_i(MEM_ctrl_mem_mux_w),
	.data_o(mux_dataMem_result_w)
    );

/****************************************
*           Signal assignment           *
****************************************/

assign funct_i_o = {IF_instr_w[30], IF_instr_w[14:12]};	
assign and_result_w = EX_alu_zero_w & EX_ctrl_branch_w;

endmodule

