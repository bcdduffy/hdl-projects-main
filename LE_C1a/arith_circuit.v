////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename: arith_circuit.v
// Author:	 Brenden Duffy
// Created:	 March 2021
// Version:  2 (modified 9 Jan 2020, KLC)
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
module arith_circuit (result, OpA, OpB, switches);
input [2:0] switches;
input [7:0] OpA, OpB;
output [7:0] result;

wire [7:0] result0, result1, result2, result3, result4, result5;
wire cout;
// Replace this assign statement with your Verilog code.
// The operation of the arithmetic circuit is defined in the  specification.
bit8_ripplecarry(result0, cout, OpA, 8'b0000_0000, 8'b0000_0000);
bit8_ripplecarry(result1, cout, 8'b0000_0000, OpB, 1'b1);
bit8_ripplecarry(result2, cout, OpA, 8'b0000_0010, 1'b0);
bit8_ripplecarry(result3, cout, OpA, OpB, 0);
bit8_ripplecarry(result4, cout, 8'b0000_0000, ~OpB, 1'b1);
bit8_ripplecarry(result5, cout, OpA, ~OpB, 1'b1);

assign result = (switches == 3'b000) ? result0 :
						(switches == 3'b001) ? result1 :
						(switches == 3'b010) ? result2 :
						(switches == 3'b011) ? result3 :
						(switches == 3'b100) ? result4 :
						(switches == 3'b101) ? result5 : 8'b0000_0000;



//assign result = 8'hB5;


endmodule

module full_adder (sum, cout, a, b, cin);
	input a, b, cin;
	output sum, cout;
	
	assign sum = a^b^cin;
	assign cout = a & b | (cin & (a^b));
endmodule

module bit8_ripplecarry (sum, cout, a, b, cin);
	input [7:0] a, b;
	input cin;
	output [7:0] sum;
	output cout;
	wire cout0, cout1, cout2, cout3, cout4, cout5, cout6;
	
	full_adder (sum[0], cout0, a[0], b[0], cin);
	full_adder (sum[1], cout1, a[1], b[1], cout0);
	full_adder (sum[2], cout2, a[2], b[2], cout1);
	full_adder (sum[3], cout3, a[3], b[3], cout2);
	full_adder (sum[4], cout4, a[4], b[4], cout3);
	full_adder (sum[5], cout5, a[5], b[5], cout4);
	full_adder (sum[6], cout6, a[6], b[6], cout5);
	full_adder (sum[7], cout, a[7], b[7], cout6);
	
	
endmodule
