// Insert a module header that describes your module appropriately.

module ssd3(in, out);
	input  [3:0] in;
	output [6:0] out;
	
	wire an, bn, cn, dn;
	wire a, b, c, d;
	
	assign a = in[3];
	assign b = in[2];
	assign c = in[1];
	assign d = in[0];
	
	assign an = ~in[3];
	assign bn = ~in[2];
	assign cn = ~in[1];
	assign dn = ~in[0];
	
assign out[0] = ~(~(a&dn) & ~(b&cn&d) & ~(bn&c&dn));

assign out[1] = a | (b&d) | (c&dn);

assign out[2] = ~(~(a&dn) & ~(an&cn&d) & ~(b&c&dn));

assign out[3] = ~(~(b&cn&d) & ~(bn&c&dn));

assign out[4] = ~(c&d);

assign out[5] = ~(an&bn&cn&d);

assign out[6] = ~(~(bn&cn&dn) & ~(b&cn&d));
	
endmodule

// If your module requires instances of other modules, you may write them here and instantiate
// them in the ssd3 module accordingly.
