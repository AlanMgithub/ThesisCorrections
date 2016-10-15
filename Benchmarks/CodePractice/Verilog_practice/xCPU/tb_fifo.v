module test;

  /* Make a reset that pulses once. */
  reg reset = 0;
  initial begin
     $dumpfile("simulation_fifo.vcd");
     $dumpvars(0,test);

	#0 reset = 0;
	#1 reset = 1;
	#2 reset = 0;

	#500 $finish;
  end

  /* Make a regular pulsing clock. */
  reg clk = 0;
  always #1 clk = !clk;

  reg [31:0] data_enq = 0;
  reg request = 1;
  wire [31:0] data_deq;
  wire empty, full;

	always #10 request = !request;
	always #20 data_enq = data_enq + 1;

  fifo c1 (	.clk(clk), 
		.reset(reset), 
		.request(request),
		.enq(data_enq),
		.deq(data_deq),
		.flag_empty(empty),
		.flag_full(full)
);

  initial
     $monitor("At time %t, inputs = |%b|%h|%h|",
              $time, request, data_enq, data_deq);
endmodule // test
