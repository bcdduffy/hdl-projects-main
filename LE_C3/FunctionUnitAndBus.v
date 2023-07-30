////////////////////////////////////////////////////////////////////////////////////////////////////
//
//	File: FunctionUnitAndBus.v
// Top-level file for Function Unit and Bus System (LE C.3)
//
// Created by J.S. Thweatt, 4 November 2019
// Based on BusControl module by Adddison Ferrari
//
// The FunctionUnitandBus module should contain both your function unit and your bus control logic.
//
// Modified by:
// 
////////////////////////////////////////////////////////////////////////////////////////////////////

// DO NOT MODIFY THE MODULE AND PORT DECLARATIONs OF THIS MODULE!

module FunctionUnitAndBus(MAX10_CLK1_50, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
	input        MAX10_CLK1_50;									// System clock
	input  [1:0] KEY;													// DE10 Pushbuttons
	input  [9:0] SW;													// DE10 Switches 
	output [6:0] HEX0;												// DE10 Seven-segment displays
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output [9:0] LEDR;												// DE10 LEDs

// END MODULE AND PORT DECLARATION

// BEGIN WIRE DECLARATION
	
// Buttons is the output of a Finite State Machine.
// Each time that one of the DE10 pushbuttons is pressed and released, the corresponding value of BUTTONS goes high for one clock period.
//	This ensures that a single press and release of a pushbutton enables only one register transfer.
// YOU MUST USE THE VALUES FROM BUTTONS INSTEAD OF tHE VALUES FROM KEY IN YOUR IMPLEMENTATION.
	
	wire [1:0] buttons;												// DO NOT MODIFY!

// These values represent the register states.
// The synthesis keep directive will allow you to view these wires in simulation.

	wire [7:0] val0 /* synthesis keep */ ;						// DO NOT MODIFY!
	wire [7:0] val1 /* synthesis keep */ ;						// DO NOT MODIFY!
	wire [7:0] val2 /* synthesis keep */ ;						// DO NOT MODIFY!
	wire [7:0] val3 /* synthesis keep */ ;						// DO NOT MODIFY!

// These values represent the inputs of your Function Unit.
// YOU MUST USE THESE NAMES AS THE INPUTS OF YOUR FUNCTION UNIT IN THE INSTANCE YOU PLACE INTO THE TOP-LEVEL MODULE!
// YOU MUST USE THESE NAMES AS THE OUTPUTS OF THE OPERAND BUSES.

	wire [7:0] operandA /* synthesis keep */ ;				// DO NOT MODIFY!
	wire [7:0] operandB /* synthesis keep */ ;				// DO NOT MODIFY!
	
// This value represents the outputs of your Function Unit.
// YOU MUST USE result AS THE RESULT OUTPUT OF YOUR FUNCTION UNIT IN THE INSTANCE YOU PLACE INTO THE TOP-LEVEL MODULE!
// YOU MUST USE V, C, N and Z AS THE STATUS OUTPUTS OF YOUR FUNCTION UNIT IN THE INSTANCE YOU PLACE INTO THE TOP-LEVEL MODULE!
	
	wire [7:0] result /* synthesis keep */ ;					// DO NOT MODIFY!
	wire V, C, N, Z  /* synthesis keep */ ;					// DO NOT MODIFY!

// This value represents the output of the bus that loads the registers.

	wire [7:0] bus /* synthesis keep */ ; 						// DO NOT MODIFY!
	
// You MAY alter this wire declarations if you wish, or even delete it entirely.
// What you replace it with will depend on your design.

	wire       load0, load1, load2, load3, enable;													// Register load

// Add your other wire declarations here

	//wire busOpA, busOpB;

// END WIRE DECLARATION
	
// BEGIN TOP-LEVEL HARDWARE MODEL //
		
// Review the hardware description for the buttonpress module in buttonpress.v.
// Use BUTTONS as the control signal for your hardware instead of KEY.
//	This ensures that a single press and release of a pushbutton enables only one register transfer.
// DO NOT CHANGE THESE INSTANTIATIONS!

//                System clock   Pushbutton  Enable
	buttonpress b1(MAX10_CLK1_50, KEY[1],     buttons[1]);
	buttonpress b0(MAX10_CLK1_50, KEY[0],     buttons[0]);
	
// Review the hardware description for the register module in register8bit.v
// YOU MAY CHANGE THE LOAD CONTROL as needed by the system you are trying to implement.
// DO NOT CHANGE THE CLOCK SOURCE, THE REGISTER INPUTS, OR THE REGISTER OUTPUTS!

//                 System clock   Load control  Register inputs  Register outputs
	register8bit r0(MAX10_CLK1_50, load0,         bus,             val0);
	register8bit r1(MAX10_CLK1_50, load1,         bus,             val1);
	register8bit r2(MAX10_CLK1_50, load2,         bus,             val2);
	register8bit r3(MAX10_CLK1_50, load3,         bus,             val3);

// Instantiate your bus hardware here. You may also use continuous assignments as needed.
// - The inputs of your operand buses are the register outputs.
// - The outputs of your operand buses MUST BE wires called operandA and operandB.
// - The destination is controlled by SW[9:8]: 00 - r0; 01 - r1; 10 - r2; 11 - r3.
// - The bus for operandA is controlled by SW[7:6]: 00 - r0; 01 - r1; 10 - r2; 11 - r3.
// - The bus for operandB is controlled by SW[5:4]: 00 - r0; 01 - r1; 10 - r2; 11 - r3.

assign operandA = (SW[7:6] == 2'b00) ? val0 :
						(SW[7:6] == 2'b01) ? val1 :  
						(SW[7:6] == 2'b10) ? val2 :
						(SW[7:6] == 2'b11) ? val3 : 8'b0000_0000;
						
assign operandB = (SW[5:4] == 2'b00) ? val0 :
						(SW[5:4] == 2'b01) ? val1 :  
						(SW[5:4] == 2'b10) ? val2 :
						(SW[5:4] == 2'b11) ? val3 : 8'b0000_0000;

assign enable = buttons[0]|buttons[1];
twoByFourDecEnable(SW[9],SW[8], enable, load0, load1, load2, load3);


						

// Instantiate your FUNCTION UNIT here.
// - The inputs of the instance MUST BE wires called operandA and operandB.
// - The result output of the instance MUST BE a wire called result.
// - The status outputs of the instance MUST be wires called V, C, N, Z.
// - The operation performed by the Function unit is controlled by SW[3:0].

function_unit funtion1(result, V, C, N, Z, operandA, operandB, SW[3:0]);


// This instance of the 8-bit 2-to-1 multiplexer buses the switches and the Function Unit result to the registers.
// - The destination register should receive the result from the Function Unit when KEY1 is pressed.
// - The destination register should receive the value from SW[7:0] when KEY0 is pressed.
// DO NOT CHANGE THIS INSTANTIATION!

   mux2to1_8bit m1(buttons[0], result, SW[7:0], bus);		

// Review the hardware description for the hexDecoder_7seg module in hexDecoder_7seg.v.
// HEX5/HEX4 must display the value of OperandA, which also comes from your operand bus.
// HEX3/HEX2 must display the value of OperandB, which also comes from your operand bus.
// HEX2/HEX0 must display the result output of the function unit.
// DO NOT CHANGE THESE INSTANTIATIONS!

//                    Upper Hex Display  Lower Hex Display  Register Value
	hexDecoder_7seg h1(HEX5,              HEX4,              operandA);
	hexDecoder_7seg h2(HEX3,              HEX2,              operandB);
	hexDecoder_7seg h3(HEX1,              HEX0,              result);

	
// The LEDs must display the status output of the Function Unit
// DO NOT CHANGE THIS CONTINUOUS ASSIGNMENT! 

	assign LEDR = {6'b000000, V, C, N, Z};
	
// END TOP-LEVEL HARDWARE MODEL //

endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////
//
//	Module: mux2to1_8bit
// 8-bit 2-to-1 multiplexer for use in the top-level module
//
//	Created by Jason Thweatt, 04 November 2019
//
// **************************
// DO NOT MODIFY THIS MODULE!
// **************************
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module mux2to1_8bit(select, in0, in1, out);
   input        select;
   input  [7:0] in0;
   input  [7:0] in1;
   output [7:0] out;
	
	assign out = (select == 1'b0) ? in0 :
	             (select == 1'b1) ? in1 : 8'bxxxxxxxx;

endmodule

// Write the remaining hardware models that you instantiate into the top-level module starting here.



///////////////// Function Unit Module

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

//////Block for Remainder 16 function

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
	
module twoByFourDecEnable(A1, A0, enable, D0, D1, D2, D3);
	input A0, A1, enable; 					
	output D0, D1, D2, D3;					
	
	assign D0 = (enable)*(~A1)*(~A0);
	assign D1 = (enable)*(~A1)*(A0);
	assign D2 = (enable)*(A1)*(~A0);
	assign D3 = (enable)*(A1)*(A0);

	
	endmodule



