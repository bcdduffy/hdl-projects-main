////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename: block1.v
// Author:	 KLC
// Created:	 10 Oct 2019
// Version:  1
// Description: The arithmetic circuit should take the operands OpA, OpB from the  
// ROM in the top level entity, and the inputs SW[2:0] from the DE10-Lite board 
// to select the operation.  The output result drives LEDs [7:0] on the DE10-Lite 
// board.
//
//  **************************************************
//  This file is the only Verilog file that you should modify.
//  It should be properly commented and formatted.
//  **************************************************
//
////////////////////////////////////////////////////////////////////////////////////////////////////

//Do not change the port declarations
module block1 (result, OpA, OpB, switches);
input [2:0] switches;
input [7:0] OpA, OpB;
output [7:0] result;


assign result = (switches == 3'b010) ? (OpA|OpB) :
						(switches == 3'b011) ? (OpA&OpB) :
						(switches == 3'b100) ? ~(OpA&OpB) :  8'b0000_0000;

// Replace this assign statement with your Verilog code.
// The operation of the arithmetic circuit is defined in the  specification.

endmodule
