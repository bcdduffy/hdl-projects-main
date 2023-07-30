// Brenden Duffy
// LE_E1 4bit counter module
// This module represents the excitation equations that drive the 4 bit register

module counter4bitlogic(present, next);
	input  [3:0] present;
	output [3:0] next;
	
	wire D3, D2, D1, D0;
	
	assign D3 = (present[3]&(~present[0])) | (present[2] & present[1] & present[0]);
	
	assign D2 = (present[2]&(~present[0])) | (present[2]&(~present[1])) | (~present[2] & present[1] & present[0]);
	
	assign D1 = ((~present[3]) & (~present[1]) & present[0]) | (present[1] & (~present[0]));
	
	assign D0 = (~present[0]);
	
// In LEARNING EXPERIENCE E.1, replace this continuous assignment with the logic that represents
// your counter logic. You may use a structural model and primitive logic gates or a continuous
// assignment model using PERMITTED dataflow operators.
	
	assign next[3] = D3;
	assign next[2] = D2;
	assign next[1] = D1;
	assign next[0] = D0;
	
endmodule


// If this module requires instances of other modules, write them starting here. 
