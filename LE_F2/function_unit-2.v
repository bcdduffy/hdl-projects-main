////////////////////////////////////////////////////////////////////////////////////////////////////
//
// File: function_unit.v
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module function_unit(FS, OpA, OpB, result, V, C, N, Z);
	input   [3:0] FS;				// Function Unit select code.
   input  [15:0] OpA;				// Function Unit operand A
   input  [15:0] OpB;				// Function Unit operand B
   output [15:0] result;		// Function Unit result
   output        V;				// Overflow status bit
   output        C;				// Carry-out status bit
   output        N;				// Negative status bit
   output        Z;				// Zero status bit
	wire lcout, lovout, acout, aovout;
	wire [15:0] resultHold; 

funct_block block(resultHold, C, V, OpA, OpB, FS);

						
	assign N = resultHold[15];
	assign Z = (resultHold == 8'b0000_0000_0000_0000) ? 1'b1: 1'b0;

assign result = resultHold;

endmodule




/////Arithmetic Block //////////////////////////////////////////////////////////////////////////////////////////////////


module funct_block (result, carry, overflow, OpA, OpB, FS);  //Arithmetic Block for functions requiring an output V, C, N, and Z
input [3:0] FS;
input [15:0] OpA, OpB;
output [15:0] result;
output carry, overflow;
wire [15:0] result8, result9, result10, result11, result12;
wire cout8, cout9, cout10, cout11, cout12;
wire ovout8, ovout9, ovout10, ovout11, ovout12;
wire [15:0] resultMult8, resultRem16;


	mult8 mult8func (resultMult8, OpB);
rem16 rem16func (resultRem16, OpB);


bit16_ripplecarry arithAdd (result8, cout8, ovout8, OpA, OpB, 0);   //Add
bit16_ripplecarry arithSub (result9, cout9, ovout9, OpA, ~OpB, 1'b1);  // SubAB
bit16_ripplecarry arithIncB (result10, cout10, ovout10, 16'b0000_0000_0000_0000, OpB, 1'b1);  // Inc B
bit16_ripplecarry arith2A (result11, cout11, ovout11, OpA, 16'b0000_0000_0000_0010, 1'b0);  // Inc2A
bit16_ripplecarry arithnegB (result12, cout12, ovout12, 16'b0000_0000_0000_0000, ~OpB, 1'b1);  //negB

assign result = (FS == 4'b1000) ? result8 :
						(FS == 4'b1001) ? result9 :
						(FS == 4'b1010) ? result10 :
						(FS == 4'b1011) ? result11 :
						(FS == 4'b1100) ? result12 : 
						(FS == 4'b0000) ? OpA :    //movA
						(FS == 4'b0001) ? ~(OpA) :  //notA
						(FS == 4'b0010) ? ~(OpB) :   //notB
						(FS == 4'b0011) ? (OpA&OpB) :   //and
						(FS == 4'b0100) ? ~(OpA&OpB) :   //nand
					   (FS == 4'b0101) ? (OpA|OpB) :    //or
					   (FS == 4'b0110) ? resultMult8:   //mult8
				      (FS == 4'b0111) ? resultRem16	:  16'b0000_0000_0000_0000;
						
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



//Block for multiply by 8 Function

module mult8 (out, OpB);
input [15:0] OpB;
output [15:0] out;
wire [15:0] result0, result1, result2, result3, result4, result5;
wire cout, ovout0, ovout1, ovout2, ovout3, ovout4, ovout5, ovout6;

bit16_ripplecarry mult0 (result0, cout, ovout0, OpB, OpB, 1'b0);
bit16_ripplecarry mult1 (result1, cout, ovout1, OpB, result0, 1'b0);
bit16_ripplecarry mult2 (result2, cout, ovout2, OpB, result1, 1'b0);
bit16_ripplecarry mult3 (result3, cout, ovout3, OpB, result2, 1'b0);
bit16_ripplecarry mult4 (result4, cout, ovout4, OpB, result3, 1'b0);
bit16_ripplecarry mult5 (result5, cout, ovout5, OpB, result4, 1'b0);
bit16_ripplecarry mult6 (out, cout, ovout6, OpB, result5, 1'b0);

endmodule

//////Block for Remainder 16 function

module rem16 (out, OpB);
input [15:0] OpB;
output [15:0] out;


assign out = {12'b0000_0000_0000, OpB[3], OpB[2], OpB[1], OpB[0]};


endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////////




module full_adder (sum, cout, a, b, cin);   //Full adder used for 8bit ripple carry
	input a, b, cin;
	output sum, cout;
	
	assign sum = a^b^cin;
	assign cout = a & b | (cin & (a^b));
endmodule

module bit16_ripplecarry (sum, cout, overout, a, b, cin);  // 8Bit ripple cary module for simple arithmetic
	input [15:0] a, b;
	input cin;
	output [15:0] sum;
	output cout;
	output overout;
	wire cout0, cout1, cout2, cout3, cout4, cout5, cout6, cout7, cout8, cout9, cout10, cout11, cout12, cout13, cout14;
	
	full_adder adder0 (sum[0], cout0, a[0], b[0], cin);
	full_adder adder1 (sum[1], cout1, a[1], b[1], cout0);
	full_adder adder2 (sum[2], cout2, a[2], b[2], cout1);
	full_adder adder3 (sum[3], cout3, a[3], b[3], cout2);
	full_adder adder4 (sum[4], cout4, a[4], b[4], cout3);
	full_adder adder5 (sum[5], cout5, a[5], b[5], cout4);
	full_adder adder6 (sum[6], cout6, a[6], b[6], cout5);
	full_adder adder7 (sum[7], cout7, a[7], b[7], cout6);
	full_adder adder8 (sum[8], cout8, a[8], b[8], cout7);
	full_adder adder9 (sum[9], cout9, a[9], b[9], cout8);
	full_adder adder10 (sum[10], cout10, a[10], b[10], cout9);
	full_adder adder11 (sum[11], cout11, a[11], b[11], cout10);
	full_adder adder12 (sum[12], cout12, a[12], b[12], cout11);
	full_adder adder13 (sum[13], cout13, a[13], b[13], cout12);
	full_adder adder14 (sum[14], cout14, a[14], b[14], cout13);
	full_adder adder15 (sum[15], cout, a[15], b[15], cout14);
	
	assign overout = cout ^ cout14;
	
	
endmodule	
	



