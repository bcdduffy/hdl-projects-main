// Insert a module header that describes your module appropriately.

module ssd1(in, out);
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
	
assign out[0] = ~(~(bn&c&dn) & ~(b&d));

assign out[1] = ~(~(an&cn) & ~(b&c&d) & ~(bn&c&dn));

assign out[2] = ~(~(an&cn&d) & ~(bn&c));

assign out[3] = ~(b&d);

assign out[4] = ~(b&dn);

assign out[5] = ~(bn&c&d);

assign out[6] = ~(~(a&dn) & ~(b&cn&d) & ~(bn&c&dn));

endmodule

// If your module requires instances of other modules, you may write them here and instantiate
// them in the ssd1 module accordingly.
