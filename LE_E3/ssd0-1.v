// Insert a module header that describes your module appropriately.

module ssd0(in, out);
	input  [3:0] in;
	output [6:0] out;

		// inverses such that in[3:0] = abcd
			wire an, bn, cn, dn;
		// out[6]
			wire h6w1, h6w2;
		// out[5]
			wire h5w1;
		// out[4]
			wire h4w1, h4w2;
		// out[3]
			wire h3w1, h3w2;
		// out[2]
			wire h2w1, h2w2, h2w3;
		// out[1]
			wire h1w1, h1n;
	   // out[0]
			wire h0w1, h0w2, h0w3;

		// nots
			not 	n3g(an, in[3]);
			not 	n2g(bn, in[2]);
			not 	n1g(cn, in[1]);
			not 	n0g(dn, in[0]);

		// out[6]
			nand 	h6g1(h6w1, an, bn, cn);				// a'b'd'
			nand 	h6g2(h6w2, in[2], in[1], in[0]);			// bc'd'
			nand 	h6g4(out[6], h6w1, h6w2);  // a'b'd' + bc' + ad

		// out[5]
			nand 	h5g1(h5w1, in[1], bn, dn);    			// bc'
			not 	h5g2(out[5], h5w1);    		// bc' + ad

		// out[4]
			nand 	h4g1(h4w1, in[2], cn, in[0]); 				   // c'd'
			nand 	h4g2(h4w2, in[2], in[1], dn);			// bc
			nand 	h4g3(out[4], h4w1, h4w2); // c'd' + bc + a

		// out[3]
			nand 	h3g1(h3w1, cn, dn, in[2]);      	// bcd
			nand 	h3g2(h3w2, an, bn, cn, in[0]);      	// bcd
			nand 	h3g3(out[3], h3w1, h3w2);	// c'd'+ bcd + a

		// out[2]
			nand 	h2g1(h2w1, an, bn, in[0]); 				   // a'b'd
			nand 	h2g2(h2w2, in[1], in[0]);  			// cd
			nand 	h2g3(h2w3, in[1], bn);  			// cb'
			nand 	h2g4(out[2], h2w1, h2w2, h2w3);	// a'b' + bc' + b'd
	
		// out[1]
		   not   h1g0(h1n, in[0]);                  //d'
			nand 	h1g1(h1w1, in[2], cn);	      		// bc'
			nand 	h1g2(out[1], h1w1, h1n); 			// bc' + d'

		// out[0]
			nand	   h0g1(h0w1, an, bn, cn, in[0]); // a'b'c'd
			nand	   h0g2(h0w2, in[2], cn, dn);       //
			nand	   h0g3(h0w3, in[2], in[1], in[0]); 
			nand	   h0g4(out[0], h0w1, h0w2, h0w3); 
			
			
			
	

endmodule

// If your module requires instances of other modules, you may write them here and instantiate
// them in the ssd0 module accordingly.
