module traffic (
	clk,
	button,
	sensor,
	red,
	amber,
	green
);

input clk, button, sensor;
output red, amber, green;

wire clk, button, sensor;
reg red, amber, green;
reg [2:0] mode;
reg [4:0] count;

	initial begin
		red = 0;
		amber = 0;
		green = 1;
		mode = 0;
		count = 0;
	end

	always @ (posedge clk)
		if (mode == 0) begin
			if (button) begin
				amber <= 1;
				green <= 0;
				mode <= 1;
			end
			else begin
				green <= 1;
			end
		end
		else if (mode == 1) begin
			red <= 1;
			amber <= 0;
			mode <= 2;
		end
		else if (mode == 2) begin
			if (count < 4) begin
				count <= count + 1;
			end
			else begin
				count <= 0;
				amber <= 1;
				red <= 0;
				mode <= 3;
			end
		end
		else if (mode == 3) begin
			if (count < 8) begin
				amber = ~amber;
				count <= count + 1;
			end
			else begin
				if (sensor) begin
					amber = ~amber;
				end
				else begin
					count <= 0;
					green <= 1;
					amber <= 0;
					mode <= 4;
				end
			end
		end
		else if (mode == 4) begin
			if (count < 16) begin
				green <= 1;
				count <= count + 1;
			end
			else begin
				mode <= 0;
				count <= 0;
			end
		end
endmodule
