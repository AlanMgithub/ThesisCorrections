module fifo (
	clk,
	reset,
	request,
	enq,
	deq,
	flag_empty,
	flag_full	
);

parameter TRUE = 1;
parameter FALSE = 0;
parameter SIZE = 1;
parameter MAX = 1<<(SIZE+1); 

input clk, reset, request;
input [31:0] enq;
output reg [31:0] deq;
output reg flag_empty, flag_full;

reg [31:0] storage [MAX];
reg [SIZE:0] write_ptr;
reg [SIZE:0] read_ptr;

initial begin
	deq = 0;
	flag_empty = TRUE;
	flag_full = FALSE;
	write_ptr = 0;
	read_ptr = 0;
	storage[0] = 0;
	storage[1] = 0;
	storage[2] = 0;
	storage[3] = 0;
end

always @ (posedge clk or posedge reset) begin
	deq <= 0;
	flag_empty <= TRUE;
	flag_full <= FALSE;
	write_ptr <= 0;
	read_ptr <= 0;
end

always @ (posedge request) begin // Write
	storage[write_ptr] <= enq;		
	write_ptr <= write_ptr + 1;		
	//$display("FIFO Write |%h|%h|", write_ptr, enq);
end

always @ (negedge request) begin // Read
	deq <= storage[read_ptr];
	read_ptr <= read_ptr + 1;
end

endmodule
