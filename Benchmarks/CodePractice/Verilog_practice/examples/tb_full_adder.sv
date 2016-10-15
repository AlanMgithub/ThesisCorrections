module test;

  /* Make a reset that pulses once. */
  reg reset = 0;
  initial begin
     $dumpfile("simulation_full_adder.vcd");
     $dumpvars(0,test);

	#0 reset = 0;
	#1 reset = 1;
	#1 reset = 0;
	#30 $finish;
  end

  /* Make a regular pulsing clock. */
  reg clk = 0;
  always #1 clk = !clk;

  reg [2:0] cinab = 0;
  wire [1:0] couts;

  always #3 cinab = cinab + 1;

  full_adder c1 (clk, reset, cinab, couts);

  initial
     $monitor("At time %t, |%b|%b|%b|%b|",
              $time, clk, reset, cinab, couts);
endmodule // test
