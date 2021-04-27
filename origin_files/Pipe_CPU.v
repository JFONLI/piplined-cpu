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


/**** ID stage ****/
//control signal...


/**** EX stage ****/
//control signal...


/**** MEM stage ****/
//control signal...


/**** WB stage ****/
//control signal...


/**** Data hazard ****/
//control signal...

Forwarding_Unit FU(
	
	);

/****************************************
*          Instantiate modules          *
****************************************/
//Instantiate the components in IF stage
Program_Counter PC(
	
	);
		
MUX_2to1 #(.size( )) Mux_PC_Source(
	
	);	

Instr_Mem IM(
	
	);
			
Adder Add_pc(

	);

//You need to instantiate many pipe_reg
Pipe_Reg #(.size( )) IF_ID(

	);
		
//Instantiate the components in ID stage
Reg_File RF(

	);

Control Control(

	);

Imm_Gen IG(
	
	);	

//You need to instantiate many pipe_reg
Pipe_Reg #(.size( )) ID_EX(

	);
				
//Instantiate the components in EX stage	   
ALU ALU(

	);
		
MUX_3to1 #(.size( )) Mux3_1(
	
    );
		
MUX_3to1 #(.size( )) Mux3_2(
	
    );
		
ALU_Ctrl AC(
	
	);

MUX_2to1 #(.size( )) Mux1(

    );
				
Shift_Left_One_64 Shifter(
	
	); 	
		
Adder Add_pc2(
	   
	);

//You need to instantiate many pipe_reg
Pipe_Reg #(.size( )) EX_MEM(
	
	);	

//Instantiate the components in MEM stage
Data_Mem DM(

	);

Pipe_Reg #(.size( )) MEM_WB(

	);

//Instantiate the components in WB stage
MUX_2to1 #(.size( )) Mux2(
	
    );

/****************************************
*           Signal assignment           *
****************************************/
	
endmodule

