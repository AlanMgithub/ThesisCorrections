#!/bin/sh
export PATH=$PATH:/mnt
clear 

mkdir tmp_dir

echo "....................... CP TESTING .............................."
echo "................................................................."
echo "Running CP test Small"
echo "Count = $c"
i=0; while [ $i -le 9 ]; do
	echo "Start"
	./GET_PERF_COUNT
	cp small_text_file.txt tmp_dir/
	./GET_PERF_COUNT
	echo "End"
i=$((i+1)); 
done

echo "................................................................."
echo "Running CP test Medium"
echo "Count = $c"
i=0; while [ $i -le 9 ]; do
	echo "Start"
	./GET_PERF_COUNT
	cp medium_text_file.txt tmp_dir/
	./GET_PERF_COUNT
	echo "End"
i=$((i+1)); 
done

echo "................................................................."
echo "Running CP test Big"
echo "Count = $c"
i=0; while [ $i -le 9 ]; do
	echo "Start"
	./GET_PERF_COUNT
	cp big_text_file.txt tmp_dir/
	./GET_PERF_COUNT
	echo "End"
i=$((i+1)); 
done

