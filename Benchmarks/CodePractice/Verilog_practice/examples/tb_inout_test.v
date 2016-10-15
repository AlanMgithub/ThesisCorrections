module test_bench_bidir;

	reg clk, rst, en = 0;
	wire [7:0] bidir;
	wire [7:0] store_inout;

	bidirectional connection_name (.clk(clk), .reset(rst), .enable(en), .bidir(bidir));	

	initial begin
		$dumpfile("dump_inout_test.vcd");
		$dumpvars(0, test_bench_bidir);

		#0 clk = 0;
		   en = 0;
		   rst = 0;
		#5 rst = 1;
		#10 rst = 0;
		#200 $finish;
	end

	always #1 clk = !clk;
	always #10 en = !en;
	assign bidir = !en ? $random : 8'bZ;
	assign store_inout = bidir;

	initial begin
		$monitor("%5d, Enable=%b, Bi-Dir=%x, Store=%x", $time, en, bidir, store_inout);
	end	

endmodule
