////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename: function_unit.v
// Author:	 KLC
// Created:	 12 Oct 2019
// Version:  2 (modified 15 Jan 2020, KLC)
// Description: The function unit should take the operands OpA, OpB from the  
// ROM in the top level entity, and the inputs SW[3:0] from the DE10-Lite board 
// to select the operation.  The outputs are the 8-bit result and 4 status bits, 
// which can be displayed on LEDs[7:0] on the DE10-Lite board.
//
//  **************************************************
//  This file is the only Verilog file that you should modify.
//  It should be properly commented and formatted.
//  **************************************************
//
////////////////////////////////////////////////////////////////////////////////////////////////////

//Do not change the port declarations
module function_unit (result, V, C, N, Z, OpA, OpB, FS);
input [3:0] FS;
input [7:0] OpA, OpB;
output [7:0] result;
output V, C, N, Z;
wire [7:0] logicResult, arithResult, resultHold;
wire acout, aovout, lcout, lovout;

logic_block logicBlock (logicResult, lcout, lovout, OpA, OpB, FS);

arith_block arithBlock (arithResult, acout, aovout, OpA, OpB, FS);

	assign resultHold = (FS == 4'b0000) ? logicResult :
						(FS == 4'b0001) ? logicResult :  
						(FS == 4'b0010) ? logicResult :
						(FS == 4'b0011) ? logicResult :
						(FS == 4'b0100) ? logicResult :
					   (FS == 4'b0101) ? logicResult :
					   (FS == 4'b0110) ? logicResult :
				      (FS == 4'b0111) ? logicResult	:  
                  (FS == 4'b1000) ? arithResult :
						(FS == 4'b1001) ? arithResult :
						(FS == 4'b1010) ? arithResult :
						(FS == 4'b1011) ? arithResult :
						(FS == 4'b1100) ? arithResult : 8'b0000_0000;
						
	assign V = (FS == 4'b0000) ? lovout :
						(FS == 4'b0001) ? lovout :  
						(FS == 4'b0010) ? lovout :
						(FS == 4'b0011) ? lovout :
						(FS == 4'b0100) ? lovout :
					   (FS == 4'b0101) ? lovout :
					   (FS == 4'b0110) ? lovout :
				      (FS == 4'b0111) ? lovout :  
                  (FS == 4'b1000) ? aovout :
						(FS == 4'b1001) ? aovout :
						(FS == 4'b1010) ? aovout :
						(FS == 4'b1011) ? aovout :
						(FS == 4'b1100) ? aovout : 1'b0;
						
	assign C = (FS == 4'b0000) ? lcout :
						(FS == 4'b0001) ? lcout :  
						(FS == 4'b0010) ? lcout :
						(FS == 4'b0011) ? lcout :
						(FS == 4'b0100) ? lcout :
					   (FS == 4'b0101) ? lcout :
					   (FS == 4'b0110) ? lcout :
				      (FS == 4'b0111) ? lcout :  
                  (FS == 4'b1000) ? acout :
						(FS == 4'b1001) ? acout :
						(FS == 4'b1010) ? acout :
						(FS == 4'b1011) ? acout :
						(FS == 4'b1100) ? acout : 1'b0;
						
	assign N = resultHold[7];
	assign Z = (resultHold == 8'b0000_0000) ? 1'b1: 1'b0;

assign result = resultHold;

endmodule

/////Arithmetic Block //////////////////////////////////////////////////////////////////////////////////////////////////


module arith_block (result, carry, overflow, OpA, OpB, FS);  //Arithmetic Block for functions requiring an output V, C, N, and Z
input [3:0] FS;
input [7:0] OpA, OpB;
output [7:0] result;
output carry, overflow;
wire [7:0] result8, result9, result10, result11, result12;
wire cout8, cout9, cout10, cout11, cout12;
wire ovout8, ovout9, ovout10, ovout11, ovout12;

bit8_ripplecarry arithAdd (result8, cout8, ovout8, OpA, OpB, 0);   //Add
bit8_ripplecarry arithSub (result9, cout9, ovout9, OpA, ~OpB, 1'b1);  // SubAB
bit8_ripplecarry arithIncB (result10, cout10, ovout10, 8'b0000_0000, OpB, 1'b1);  // Inc B
bit8_ripplecarry arith2A (result11, cout11, ovout11, OpA, 8'b0000_0010, 1'b0);  // Inc2A
bit8_ripplecarry arithnegB (result12, cout12, ovout12, 8'b0000_0000, ~OpB, 1'b1);  //negB

assign result = (FS == 4'b1000) ? result8 :
						(FS == 4'b1001) ? result9 :
						(FS == 4'b1010) ? result10 :
						(FS == 4'b1011) ? result11 :
						(FS == 4'b1100) ? result12 : 8'b0000_0000;
						
assign carry = (FS == 4'b1000) ? cout8 :
						(FS == 4'b1001) ? cout9 :
						(FS == 4'b1010) ? cout10 :
						(FS == 4'b1011) ? cout11 :
						(FS == 4'b1100) ? cout12 : 1'b0;
						
assign overflow = (FS == 4'b1000) ? ovout8 :
						(FS == 4'b1001) ? ovout9 :
						(FS == 4'b1010) ? ovout10 :
						(FS == 4'b1011) ? ovout11 :
						(FS == 4'b1100) ? ovout12 : 1'b0;

endmodule

///Logic Functions ///////////////////////////////////////////////////////////////////////////////////////////

module logic_block (result, carry, overflow, OpA, OpB, FS);  //LogicBlock for funtions that only need outputs Z and N
input [3:0] FS;
input [7:0] OpA, OpB;
output [7:0] result;
wire [7:0] resultMult8, resultRem16;
output carry, overflow;
	
	mult8 mult8func (resultMult8, OpB);
rem16 rem16func (resultRem16, OpB);
	
	
	assign result = (FS == 4'b0000) ? OpA :    //movA
						(FS == 4'b0001) ? ~(OpA) :  //notA
						(FS == 4'b0010) ? ~(OpB) :   //notB
						(FS == 4'b0011) ? (OpA&OpB) :   //and
						(FS == 4'b0100) ? ~(OpA&OpB) :   //nand
					   (FS == 4'b0101) ? (OpA|OpB) :    //or
					   (FS == 4'b0110) ? resultMult8:   //mult8
				      (FS == 4'b0111) ? resultRem16	:  8'b0000_0000;
	
	assign carry = 1'b0;
	assign overflow = 1'b0;
	
	
endmodule

//Block for multiply by 8 Function

module mult8 (out, OpB);
input [7:0] OpB;
output [7:0] out;
wire [7:0] result0, result1, result2, result3, result4, result5;
wire cout, ovout0, ovout1, ovout2, ovout3, ovout4, ovout5, ovout6;

bit8_ripplecarry mult0 (result0, cout, ovout0, OpB, OpB, 1'b0);
bit8_ripplecarry mult1 (result1, cout, ovout1, OpB, result0, 1'b0);
bit8_ripplecarry mult2 (result2, cout, ovout2, OpB, result1, 1'b0);
bit8_ripplecarry mult3 (result3, cout, ovout3, OpB, result2, 1'b0);
bit8_ripplecarry mult4 (result4, cout, ovout4, OpB, result3, 1'b0);
bit8_ripplecarry mult5 (result5, cout, ovout5, OpB, result4, 1'b0);
bit8_ripplecarry mult6 (out, cout, ovout6, OpB, result5, 1'b0);

endmodule

//Block for Remainder 16 function

module rem16 (out, OpB);
input [7:0] OpB;
output [7:0] out;


assign out = {4'b0000, OpB[3], OpB[2], OpB[1], OpB[0]};


endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////////




module full_adder (sum, cout, a, b, cin);   //Full adder used for 8bit ripple carry
	input a, b, cin;
	output sum, cout;
	
	assign sum = a^b^cin;
	assign cout = a & b | (cin & (a^b));
endmodule

module bit8_ripplecarry (sum, cout, overout, a, b, cin);  // 8Bit ripple cary module for simple arithmetic
	input [7:0] a, b;
	input cin;
	output [7:0] sum;
	output cout;
	output overout;
	wire cout0, cout1, cout2, cout3, cout4, cout5, cout6;
	
	full_adder adder0 (sum[0], cout0, a[0], b[0], cin);
	full_adder adder1 (sum[1], cout1, a[1], b[1], cout0);
	full_adder adder2 (sum[2], cout2, a[2], b[2], cout1);
	full_adder adder3 (sum[3], cout3, a[3], b[3], cout2);
	full_adder adder4 (sum[4], cout4, a[4], b[4], cout3);
	full_adder adder5 (sum[5], cout5, a[5], b[5], cout4);
	full_adder adder6 (sum[6], cout6, a[6], b[6], cout5);
	full_adder adder7 (sum[7], cout, a[7], b[7], cout6);
	
	assign overout = (cout != cout6) ? 1'b1 : 1'b0;
	
	
endmodule	
	