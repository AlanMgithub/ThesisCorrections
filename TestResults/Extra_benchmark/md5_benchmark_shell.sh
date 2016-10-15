#!/bin/sh
export PATH=$PATH:/mnt
clear 

echo "...................... MD5 TESTING .............................."
echo "................................................................."
echo "Running MD5 test Small"
echo "Count = $c"
i=0; while [ $i -le 9 ]; do
	echo "Start"
	./GET_PERF_COUNT
	/sbin/md5 small_text_file.txt
	./GET_PERF_COUNT
	echo "End"
i=$((i+1)); 
done

echo "................................................................."
echo "Running MD5 test Medium"
echo "Count = $c"
i=0; while [ $i -le 9 ]; do
	echo "Start"
	./GET_PERF_COUNT
	/sbin/md5 medium_text_file.txt
	./GET_PERF_COUNT
	echo "End"
i=$((i+1)); 
done

echo "................................................................."
echo "Running MD5 test Big"
echo "Count = $c"
i=0; while [ $i -le 9 ]; do
	echo "Start"
	./GET_PERF_COUNT
	/sbin/md5 big_text_file.txt
	./GET_PERF_COUNT
	echo "End"
i=$((i+1)); 
done

