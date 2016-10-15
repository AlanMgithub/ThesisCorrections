module cpu (
	clk,
	reset,
	instruction,
	answer
);

// Inputs *****************************************************
input clk, reset;
input [31:0] instruction;
// Outputs ****************************************************
output reg [31:0] answer;

// Wires ******************************************************
wire clk, reset;
// Registers **************************************************
reg [31:0] inst;

// Architectural Registers ************************************
reg [31:0] archReg [4:0]; // 32 registers, storing 32 bits
reg [2:0] opCode; // 8 opcodes
reg [4:0] rDest; // destination register
reg [4:0] rSourceA; // source register A
reg [4:0] rSourceB; // source register B
reg [4:0] jump; // jump register 
reg [4:0] ret; // ret register

// Other Regs *************************************************
reg exception; 

initial begin
	answer <= 0;
	archReg[0] <= 0;
	archReg[1] <= 0;
	exception <= 0;
end

always @ (posedge clk or posedge reset) begin
	if (reset) begin
		answer <= 0;
		exception <= 0;
	end
	else begin
		rDest =  instruction[31:27];
		rSourceA = instruction[26:22];
		rSourceB = instruction[21:17];
		jump = instruction[13:9];
		ret = instruction[8:4];
		opCode = instruction[16:14];	
	
		if (rDest == 0 || rDest == 1) begin
			exception = 1;
			$display("#Instruction *** EXCEPTION *** WARNING ***");
		end

		case (opCode && !exception) 
			0: begin
				$display("#Instruction ADD");
				archReg[rDest] = archReg[rSourceA] + archReg[rSourceB];
			end
			1: begin
				$display("#Instruction SUB");
				archReg[rDest] = archReg[rSourceA] - archReg[rSourceB];
			end
			2: begin
				$display("#Instruction SLL");
				archReg[rDest] = archReg[rSourceA] << archReg[rSourceB];
			end
			3: begin
				$display("#Instruction SRL");
				archReg[rDest] = archReg[rSourceA] >> archReg[rSourceB];
			end
			4: begin
				$display("#Instruction AND");
				archReg[rDest] = archReg[rSourceA] & archReg[rSourceB];
			end
			5: begin
				$display("#Instruction OR");
				archReg[rDest] = archReg[rSourceA] | archReg[rSourceB];
			end
			6: begin
				$display("#Instruction JUMP");
			end
			7: begin 
				$display("#Instruction RET");
			end
			default: begin
				$display("#Instruction UNKNOWN");
				rDest = 0;
			end
		endcase

		answer <= archReg[rDest];
		exception = 0;
	end
end

endmodule
