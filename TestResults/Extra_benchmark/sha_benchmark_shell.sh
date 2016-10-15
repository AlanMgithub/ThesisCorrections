#!/bin/sh
export PATH=$PATH:/mnt
clear 

echo "...................... SHA TESTING .............................."
echo "................................................................."
echo "Running SHA test Small"
echo "Count = $c"
i=0; while [ $i -le 9 ]; do
	echo "Start"
	./GET_PERF_COUNT
	/sbin/sha256 small_text_file.txt
	./GET_PERF_COUNT
	echo "End"
i=$((i+1)); 
done

echo "................................................................."
echo "Running SHA test Medium"
echo "Count = $c"
i=0; while [ $i -le 9 ]; do
	echo "Start"
	./GET_PERF_COUNT
	/sbin/sha256 medium_text_file.txt
	./GET_PERF_COUNT
	echo "End"
i=$((i+1)); 
done

echo "................................................................."
echo "Running SHA test Big"
echo "Count = $c"
i=0; while [ $i -le 9 ]; do
	echo "Start"
	./GET_PERF_COUNT
	/sbin/sha256 big_text_file.txt
	./GET_PERF_COUNT
	echo "End"
i=$((i+1)); 
done

