#!/bin/sh
export PATH=$PATH:/mnt
clear 

echo "Running LU Contiguous test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./DIRECTORY_GET_PERF_COUNT
  ./LU_CON -p2; i=$((i+1)); 
  ./DIRECTORY_GET_PERF_COUNT
  echo "End"
done

echo "Running LU Non Contiguous test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./DIRECTORY_GET_PERF_COUNT
  ./LU_NON_CON -p2; i=$((i+1)); 
  ./DIRECTORY_GET_PERF_COUNT
  echo "End"
done

echo "Running WATER Nsquared test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./DIRECTORY_GET_PERF_COUNT
  ./WATER-NSQUARED < input_water_2core; i=$((i+1)); 
  ./DIRECTORY_GET_PERF_COUNT
  echo "End"
done

echo "Running WATER Sequential test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./DIRECTORY_GET_PERF_COUNT
  ./WATER-SPATIAL < input_water_2core; i=$((i+1)); 
  ./DIRECTORY_GET_PERF_COUNT
  echo "End"
done

echo "Running RADIX test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./DIRECTORY_GET_PERF_COUNT
  ./RADIX -p2; i=$((i+1)); 
  ./DIRECTORY_GET_PERF_COUNT
  echo "End"
done

echo "Running FFT easy test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./DIRECTORY_GET_PERF_COUNT
  ./FFT -p2; i=$((i+1)); 
  ./DIRECTORY_GET_PERF_COUNT
  echo "End"
done

echo "Running FFT hard test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./DIRECTORY_GET_PERF_COUNT
  ./FFT -p2 -m14 -l6; i=$((i+1)); 
  ./DIRECTORY_GET_PERF_COUNT
  echo "End"
done

echo "Running FMM 256 test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./DIRECTORY_GET_PERF_COUNT
  ./FMM < input.256; i=$((i+1)); 
  ./DIRECTORY_GET_PERF_COUNT
  echo "End"
done

echo "Running FMM 2048 test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./DIRECTORY_GET_PERF_COUNT
  ./FMM < input.2048; i=$((i+1)); 
  ./DIRECTORY_GET_PERF_COUNT
  echo "End"
done

echo "Running Ocean Contiguous test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./DIRECTORY_GET_PERF_COUNT
  ./OCEAN_CON -p2; i=$((i+1)); 
  ./DIRECTORY_GET_PERF_COUNT
  echo "End"
done

echo "Running Ocean Non Contiguous test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./DIRECTORY_GET_PERF_COUNT
  ./OCEAN_NON_CON -p2; i=$((i+1)); 
  ./DIRECTORY_GET_PERF_COUNT
  echo "End"
done

exit 0
