module test;

  /* Make a reset that pulses once. */
  reg reset = 0;
  initial begin
     $dumpfile("test.vcd");
     $dumpvars(0,test);

     # 17 reset = 1;
     # 11 reset = 0;
     # 29 reset = 1;
     # 5  reset =0;
     # 513 $finish;
  end

  /* Make a regular pulsing clock. */
  reg clk = 0;
  always #1 clk = !clk;

  wire [3:0] value;
  wire bool_out, task_out;
  counter c1 (value, clk, reset, bool_out, task_out);

  initial
     $monitor("At time %t, value = %h (%0d), bool_out = %h, task_out = %h",
              $time, value, value, bool_out, task_out);
endmodule // test
