module bidirectional (reset, clk, bidir, enable);

input reset, clk, enable;
inout [7:0] bidir;

reg [7:0] counter;
wire [7:0] tmp;

initial begin
	counter = 0;
end

assign bidir = enable ? counter : 8'bZ;

always @ (posedge clk) begin
	if (reset) begin
		counter <= 0;
	end
	else begin
		counter <= counter + bidir;
	end
end

endmodule
