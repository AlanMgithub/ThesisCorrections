#!/usr/bin/perl

=begin comment
* this is a comment, line 1
* comment line 2
=cut 

# This is a comment too

$var1 = 0; # Variable declaration and init
$var2 = 1;

print "Var1 = $var1\n";
print "Var2 = $var2\n";

@array = (1,2,3,4,5);
print "Array = $array[0],$array[1],$array[2]\n";

%hash = ('one', 1, 'two', 2, 'three', 3);
print "Hash = $hash{'one'}, $hash{'two'}, $hash{'three'}\n";
