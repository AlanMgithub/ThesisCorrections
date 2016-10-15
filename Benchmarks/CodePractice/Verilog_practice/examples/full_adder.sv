module full_adder (
	input clk,
	input reset,
	input [2:0] cinab,
	output [1:0] couts
);

wire [2:0] cinab;

// CLOCKED VERSION OF THE CODE *************************************************
/*
reg [1:0] couts = 0;

always @ (posedge clk or posedge reset)
	if (reset) begin
		couts = 0;
	end
	else begin
		couts[1] = (cinab[0] & cinab[1]) | (cinab[0] & cinab[2]) | (cinab[1] & cinab[2]);	
		couts[0] = (cinab[0]^cinab[1])^cinab[2]; 
	end
*/

// DIRECT VERSION OF THE CODE *************************************************
wire [1:0] out;

	assign out[1] = (cinab[0] & cinab[1]) | (cinab[0] & cinab[2]) | (cinab[1] & cinab[2]);
	assign out[0] = (cinab[0]^cinab[1])^cinab[2];
	assign couts = out;

endmodule
