module test;

  /* Make a reset that pulses once. */
  reg reset = 0;
  initial begin
     $dumpfile("simulation_xcpu.vcd");
     $dumpvars(0,test);

	#0 reset = 0;
	#1 reset = 1;
	#2 reset = 0;

	#5000 $finish;
  end

  /* Make a regular pulsing clock. */
  reg clk = 0;
  always #1 clk = !clk;

  reg [31:0] instruction = 0;
  wire [31:0] answer;

  always #5 instruction[16:14] <= instruction[16:14] + 1;
  always #10 instruction[31:27] <= instruction[31:27] + 1;
  always #10 instruction[26:22] <= instruction[26:22] + 111;
  always #15 instruction[21:17] <= instruction[21:17] + 11; 
  cpu c1 (clk, reset, instruction, answer);

  initial
     $monitor("At time %t, inputs = |%h|%h|",
              $time,  instruction, answer);
endmodule // test
