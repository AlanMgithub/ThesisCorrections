module test;

  /* Make a reset that pulses once. */
  reg button = 0;
  reg sensor = 0;
  initial begin
     $dumpfile("traffic.vcd");
     $dumpvars(0,test);
	$display("At time %t, light = |r|a|g| inputs = |b|s|", $time);
	$display("************************************************************");
/*
	#1 button = 0;
	#1 sensor = 0;
	#50 button = 1;
	#10 button = 0;
	#10 sensor = 1;
	#10 sensor = 0;
	#100 button = 1;
	#130 button = 0;
*/
	#200 $finish;
  end

	always #11 button = ~button;
	always #29 sensor = ~sensor;

  /* Make a regular pulsing clock. */
  reg clk = 0;
  always #0.5 clk = !clk;

  traffic c1 (clk, button, sensor, red, amber, green);

  initial
     $monitor("At time %t, light = |%b|%b|%b| inputs = |%b|%b|",
              $time, red, amber, green, button, sensor);
endmodule // test
