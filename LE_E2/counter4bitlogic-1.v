// Brenden Duffy
// LE_C1 4bitCounter, progresses through 10 states to drive the lights on the HEX display

module counter4bitlogic(present, next);
	input  [3:0] present;
	output [3:0] next;
	
	wire D3, D2, D1, D0;
	
	assign D3 = (present[3]&(~present[0])) | (present[2] & present[1] & present[0]);
	
	assign D2 = (present[2]&(~present[0])) | (present[2]&(~present[1])) | (~present[2] & present[1] & present[0]);
	
	assign D1 = ((~present[3]) & (~present[1]) & present[0]) | (present[1] & (~present[0]));
	
	assign D0 = (~present[0]);
	
	
	assign next[3] = D3;
	assign next[2] = D2;
	assign next[1] = D1;
	assign next[0] = D0;
	
endmodule


