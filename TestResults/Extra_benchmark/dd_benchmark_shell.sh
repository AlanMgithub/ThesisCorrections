#!/bin/sh
export PATH=$PATH:/mnt
clear 

echo "....................... DD TESTING .............................."
echo "................................................................."
echo "Running DD test 1K"
mul=10;
c=1; while [ $c -le 100000 ]; do
	echo "Count = $c"
	i=0; while [ $i -le 4 ]; do
		dd if=/dev/zero of=/dev/null bs=1K count=$c	
	i=$((i+1)); 
	done
c=`expr $c \\* $mul`; 
done

echo "................................................................."
echo "Running DD test 10K"
mul=10;
c=1; while [ $c -le 10000 ]; do
	echo "Count = $c"
	i=0; while [ $i -le 4 ]; do
		dd if=/dev/zero of=/dev/null bs=10K count=$c	
	i=$((i+1)); 
	done
c=`expr $c \\* $mul`; 
done

echo "................................................................."
echo "Running DD test 100K"
mul=10;
c=1; while [ $c -le 1000 ]; do
	echo "Count = $c"
	i=0; while [ $i -le 4 ]; do
		dd if=/dev/zero of=/dev/null bs=100K count=$c	
	i=$((i+1)); 
	done
c=`expr $c \\* $mul`; 
done

echo "................................................................."
echo "Running DD test 1M"
mul=10;
c=1; while [ $c -le 100 ]; do
	echo "Count = $c"
	i=0; while [ $i -le 4 ]; do
		dd if=/dev/zero of=/dev/null bs=1M count=$c	
	i=$((i+1)); 
	done
c=`expr $c \\* $mul`; 
done




