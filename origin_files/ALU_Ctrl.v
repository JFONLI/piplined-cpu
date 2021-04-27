module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [4-1:0] funct_i;
input      [2-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter


//Select exact operation, please finish the following code
always@(funct_i or ALUOp_i) begin
    case(ALUOp_i)
        2'b10: 
            begin
                case(funct_i)
                    4'b0111: ALUCtrl_o = 4'b0000; // AND
                    default: ALUCtrl_o = 4'b1111;
                endcase
            end
        default:
    endcase
end
endmodule