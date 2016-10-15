module test();
reg a;
reg b;
reg c;
wire out;
reg[7] range;

always
repeat(24)
begin
#100
a = 1'b1;
b = 1'b1;


#100
a = 1'b0;
b = 1'b1;

end


always@(a or b)
begin
repeat(24)
begin
range = 55 + $random % 23;
end
$monitor("%d",range);
end

endmodule
