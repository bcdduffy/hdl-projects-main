////////////////////////////////////////////////////////////////////////////////////////////////////
//
// File: pc_controller.v
//
// Description: This is a model of the Program Counter controller for the Simple Computer.
//
//              The Program Counter's next value depends on the kind of instruction being executed.
//              - The Jump instruction uses an address value from the instruction's target register
//                as its destination.
//              - The Branch instructions use an address offset contained in the instruction code,
//                and are also dependent in part upon status flags N and Z.
//              - All other instructions cause PC to advance to the next consecutive instruction.
//
// Created: 06/2012, Xin Xin, Virginia Tech
// Modified by KLC, Nov 2015 to fix R6/R7 LED viewing.
// Modified by Addison Ferrari, July 2019 to reduce amount of procedural verilog and increase
//          readability.
// Modified by JST, October 2019 to remove hidden control references.
// Modified by KLC, March 2020 to remove "+" operator
// Modified by KLC, Feb 2021 to eliminate "half_adder" name conflict
//
// ** Note that this modules uses Verilog constructs that you are NOT permitted to use in your code ** 
// 
////////////////////////////////////////////////////////////////////////////////////////////////////

module pc_controller(clock, reset, V, C, N, Z, PL, JB, BC, branch_offset, jump_addr, PC);
	input         clock;				// CPU clock
	input         reset;				// CPU reset
	input         V;					// Overflow status bit
	input         C;					// Carry status bit
	input         N;					// Negative status bit
	input         Z;					// Zero status bit
	input         PL;					// Program Counter Load
	input         JB;					// Jump/Branch Control
	input         BC;					// Branch Condition
	input  [15:0] jump_addr;		// Jump Address
	input  [15:0] branch_offset;	// Branch Offset
	output [15:0] PC;					// PC value
	reg    [15:0] PC;

	wire   [15:0] next_pc;
	wire   [15:0] pc_inc;

	wire	 [15:0] result, PCcarry;
	wire cout, ovout, cout1, ovout1;
	
	// Register that increments the PC at every positive clock edge
	always@(posedge clock) begin
		if(reset)
			PC <= 16'h0000;
		else
			PC <= next_pc;
	end
	
	// Logic to decide what is the next PC value based upon the control bits (PL, JB, BC) and the status bits (N, Z)
	// YOU WILL HAVE TO MODIFY THIS LOGIC IN LEARNING EXPERIENCE F.3.

   assign next_pc = (reset == 1'b1)                           ? 16'h0000           :	// Reset: next_PC = 0
                    (PL&JB == 1'b1)                           ? jump_addr          :	// JUMP: next_PC = jump_address
						  (PL&~JB&~Z == 1'b1)										? result				:
                                                                pc_inc;			         // Default: next_PC = PC + 1 

   incrementer PCINC (pc_inc, PC);
	
	

	bit16_ripplecarry2 offsetAddition2(result, cout, ovout, PC, branch_offset, 1'b0);   //Add
	
	

endmodule


module incrementer (inc_output, inc_input);
   input [15:0] inc_input;
	output [15:0] inc_output;
	wire [16:1] C;
	
	halfadd HA0 (inc_output[0], C[1], inc_input[0], 1'b1);
	halfadd HA1 (inc_output[1], C[2], inc_input[1], C[1]);
	halfadd HA2 (inc_output[2], C[3], inc_input[2], C[2]);
	halfadd HA3 (inc_output[3], C[4], inc_input[3], C[3]);
	halfadd HA4 (inc_output[4], C[5], inc_input[4], C[4]);
	halfadd HA5 (inc_output[5], C[6], inc_input[5], C[5]);
	halfadd HA6 (inc_output[6], C[7], inc_input[6], C[6]);
	halfadd HA7 (inc_output[7], C[8], inc_input[7], C[7]);
	halfadd HA8 (inc_output[8], C[9], inc_input[8], C[8]);
	halfadd HA9 (inc_output[9], C[10], inc_input[9], C[9]);
	halfadd HA10 (inc_output[10], C[11], inc_input[10], C[10]);
	halfadd HA11 (inc_output[11], C[12], inc_input[11], C[11]);
	halfadd HA12 (inc_output[12], C[13], inc_input[12], C[12]);
	halfadd HA13 (inc_output[13], C[14], inc_input[13], C[13]);
	halfadd HA14 (inc_output[14], C[15], inc_input[14], C[14]);
	halfadd HA15 (inc_output[15], C[16], inc_input[15], C[15]);

endmodule 

module halfadd (S,C,X,Y);
   input X, Y;
	output S, C;
	assign S = X^Y;
	assign C = X&Y;
endmodule







//////////////////////////////////////////////////////////////////////////////////////////////////////   For Branch Offset addition




module full_adder2 (sum, cout, a, b, cin);   //Full adder used for 8bit ripple carry
	input a, b, cin;
	output sum, cout;
	
	assign sum = a^b^cin;
	assign cout = a & b | (cin & (a^b));
endmodule

module bit16_ripplecarry2 (sum, cout, overout, a, b, cin);  // 8Bit ripple cary module for simple arithmetic
	input [15:0] a, b;
	input cin;
	output [15:0] sum;
	output cout;
	output overout;
	wire cout0, cout1, cout2, cout3, cout4, cout5, cout6, cout7, cout8, cout9, cout10, cout11, cout12, cout13, cout14;
	
	full_adder2 adder0 (sum[0], cout0, a[0], b[0], cin);
	full_adder2 adder1 (sum[1], cout1, a[1], b[1], cout0);
	full_adder2 adder2 (sum[2], cout2, a[2], b[2], cout1);
	full_adder2 adder3 (sum[3], cout3, a[3], b[3], cout2);
	full_adder2 adder4 (sum[4], cout4, a[4], b[4], cout3);
	full_adder2 adder5 (sum[5], cout5, a[5], b[5], cout4);
	full_adder2 adder6 (sum[6], cout6, a[6], b[6], cout5);
	full_adder2 adder7 (sum[7], cout7, a[7], b[7], cout6);
	full_adder2 adder8 (sum[8], cout8, a[8], b[8], cout7);
	full_adder2 adder9 (sum[9], cout9, a[9], b[9], cout8);
	full_adder2 adder10 (sum[10], cout10, a[10], b[10], cout9);
	full_adder2 adder11 (sum[11], cout11, a[11], b[11], cout10);
	full_adder2 adder12 (sum[12], cout12, a[12], b[12], cout11);
	full_adder2 adder13 (sum[13], cout13, a[13], b[13], cout12);
	full_adder2 adder14 (sum[14], cout14, a[14], b[14], cout13);
	full_adder2 adder15 (sum[15], cout, a[15], b[15], cout14);
	
	assign overout = cout ^ cout14;
	
	
endmodule	
	



