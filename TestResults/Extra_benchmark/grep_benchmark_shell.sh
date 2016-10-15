#!/bin/sh
export PATH=$PATH:/mnt
clear 

echo "..................... GREP TESTING .............................."
echo "................................................................."
echo "Running GREP test 'x'"
echo "Count = $c"
i=0; while [ $i -le 9 ]; do
	echo "Start"
	./GET_PERF_COUNT
	grep 'x' random_text_file.txt > tmp	
	./GET_PERF_COUNT
	echo "End"
i=$((i+1)); 
done

echo "................................................................."
echo "Running GREP test '*'"
echo "Count = $c"
i=0; while [ $i -le 9 ]; do
	echo "Start"
	./GET_PERF_COUNT
	grep '*' random_text_file.txt > tmp	
	./GET_PERF_COUNT
	echo "End"
i=$((i+1)); 
done

echo "................................................................."
echo "Running GREP test '1'"
echo "Count = $c"
i=0; while [ $i -le 9 ]; do
	echo "Start"
	./GET_PERF_COUNT
	grep '1' random_text_file.txt > tmp	
	./GET_PERF_COUNT
	echo "End"
i=$((i+1)); 
done

