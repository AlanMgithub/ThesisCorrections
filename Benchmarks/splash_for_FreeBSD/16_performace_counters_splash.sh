#!/bin/sh
export PATH=$PATH:/mnt
clear 

echo "Running LU Contiguous test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./GET_PERF_COUNT
  ./LU_CON -p16 > tmp; 
  i=$((i+1)); 
  ./GET_PERF_COUNT
  echo "End"
done

echo "Running LU Non Contiguous test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./GET_PERF_COUNT
  ./LU_NON_CON -p16 > tmp; 
  i=$((i+1)); 
  ./GET_PERF_COUNT
  echo "End"
done

echo "Running WATER Nsquared test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./GET_PERF_COUNT
  ./WATER-NSQUARED < 16_input_water_2core > tmp; 
  i=$((i+1)); 
  ./GET_PERF_COUNT
  echo "End"
done

echo "Running WATER Sequential test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./GET_PERF_COUNT
  ./WATER-SPATIAL < 16_input_water_2core > tmp; 
  i=$((i+1)); 
  ./GET_PERF_COUNT
  echo "End"
done

echo "Running RADIX test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./GET_PERF_COUNT
  ./RADIX -p16 > tmp; 
  i=$((i+1)); 
  ./GET_PERF_COUNT
  echo "End"
done

echo "Running FFT easy test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./GET_PERF_COUNT
  ./FFT -p16 > tmp; 
  i=$((i+1)); 
  ./GET_PERF_COUNT
  echo "End"
done

echo "Running FFT hard test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./GET_PERF_COUNT
  ./FFT -p16 -m14 -l6 > tmp; 
  i=$((i+1)); 
  ./GET_PERF_COUNT
  echo "End"
done

echo "Running FMM 256 test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./GET_PERF_COUNT
  ./FMM < 16_fmm_input_256 > tmp; 
  i=$((i+1)); 
  ./GET_PERF_COUNT
  echo "End"
done

echo "Running FMM 2048 test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./GET_PERF_COUNT
  ./FMM < 16_fmm_input_2048 > tmp; 
  i=$((i+1)); 
  ./GET_PERF_COUNT
  echo "End"
done

echo "Running Ocean Contiguous test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./GET_PERF_COUNT
  ./OCEAN_CON -p16 > tmp; 
  i=$((i+1)); 
  ./GET_PERF_COUNT
  echo "End"
done

echo "Running Ocean Non Contiguous test."
i=0; while [ $i -le 12 ]; do
  echo "Start"
  ./GET_PERF_COUNT
  ./OCEAN_NON_CON -p16 > tmp; 
  i=$((i+1)); 
  ./GET_PERF_COUNT
  echo "End"
done

exit 0
