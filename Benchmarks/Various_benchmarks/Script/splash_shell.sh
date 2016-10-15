#!/bin/sh
export PATH=$PATH:/mnt
clear 

echo "Running LU Contiguous test."
i=0; while [ $i -le 12 ]; do ./LU_CON -p2; i=$((i+1)); done

echo "Running LU Non Contiguous test."
i=0; while [ $i -le 12 ]; do ./LU_NON -p2; i=$((i+1)); done

echo "Running WATER Nsquared test." #input_water_2core, random.in
i=0; while [ $i -le 12 ]; do ./WATER_N < in_water; i=$((i+1)); done

echo "Running WATER Sequential test."
i=0; while [ $i -le 12 ]; do ./WATER_S < in_water; i=$((i+1)); done

echo "Running RADIX test."
i=0; while [ $i -le 12 ]; do ./RADIX -p2; i=$((i+1)); done

echo "Running FFT easy test." #FFT_PARSEC_VERSION
i=0; while [ $i -le 12 ]; do ./FFT -p2; i=$((i+1)); done

echo "Running FFT hard test."
i=0; while [ $i -le 12 ]; do ./FFT -p2 -m14 -l6; i=$((i+1)); done

echo "Running FMM 256 test." #FMM_PARSEC_VERSION, inputs_fmm/input.256 {2048}
i=0; while [ $i -le 12 ]; do ./FMM < in.256; i=$((i+1)); done

echo "Running FMM 2048 test."
i=0; while [ $i -le 12 ]; do ./FMM < in.2048; i=$((i+1)); done

echo "Running Ocean Contiguous test."
i=0; while [ $i -le 12 ]; do ./OCEAN_CON -p2; i=$((i+1)); done

echo "Running Ocean Non Contiguous test."
i=0; while [ $i -le 12 ]; do ./OCEAN_NON -p2; i=$((i+1)); done

exit 0
