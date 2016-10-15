module counter(out, clk, reset, bool_out, task_out);

  parameter WIDTH = 4;

  output [WIDTH-1 : 0] out;
  output bool_out, task_out;
  input clk, reset;

  wire clk, reset;
  wire bool_out = reset > clk;

  reg [WIDTH-1 : 0] out;
  reg [WIDTH-1 : 0] tmp;
  reg [WIDTH-1 : 0] count;
  reg task_out;

  reg i;

  specify
    (tmp => out) = 3;
  endspecify

  initial begin
    i = 0;
    repeat (WIDTH) begin
      out[i] = 1;
      i = i + 1;
    end
    //task_out = neg_clk_task(clk);
  end

  task neg_clk_task;
    input clk;
    output out;
    begin
      out = ~clk;
    end
  endtask

  always @(posedge clk)
    if (reset) begin
      out <= 0;
      count <= 0;
      tmp <= 0;
    end
    else begin
      if (!count[2] && !count[1]) begin
        tmp <= count;
      end
      out <= tmp;
      count <= count + 1; 
    end

endmodule // counter
