// AND gate primitive
primitive udp_and_gate (
	c,
	a,
	b
);

input a, b;
output c;

table
	1 1 : 1;
	? 0 : 0;
	0 ? : 0;
endtable

endprimitive

// D-latch primitive
primitive udp_d_latch (
	q,
	clk,
	d
);

output q;
input d, clk;

reg q;

table
	// transition from 0
	(01) 0 : ? : 0;
	(01) 1 : ? : 1;
	(0?) 0 : 0 : 0;
	(0?) 1 : 1 : 1; 
	// transition to 0
	(?0) ? : ? : -;
	// static clock
	(??) ? : ? : -;
endtable

endprimitive

// Testbench module
module tb_for_primitive;

reg x, y, clk, in;
wire z, out, meta_out;

always #1 clk = ~clk;

initial begin
	$dumpfile("example3.vcd");
	$dumpvars(0, tb_for_primitive);
	x = 0;
	y = 0;
	in = 0;
	clk = 0;
	#5 x = 1;
	#0 y = 0;
	#0 in = 1;
	#5 x = 0;
	#0 y = 1;
	#0 in = 0;
	#5 x = 1;
	#0 y = 1;
	#0 in = 1;
	$finish;
end

initial
	$monitor("AND x:%b, y:%b, z:%b | D-LATCH clk:%b, in:%b, out:%b | META D-LATCH clk:%b, out-in:%b, meta-out:%b", x, y, z, clk, in, out, clk, out, meta_out); 

	udp_and_gate connection1 (z, x, y);
	udp_d_latch connection2 (out, clk, in);	
	udp_d_latch connection3 (meta_out, clk, out);	

endmodule
