#!/bin/sh
export PATH=$PATH:/mnt
clear 

const=2

echo "Running LU Contiguous test."
i=0; while [ $i -le 5 ]; do 
	#echo "LU_CON -n128 -p$const"
	j=0; while [ $j -le 5 ]; do 
		x=$const;
		echo "LU_CON -n128 -p$const"
		echo "Start"
  		./DIRECTORY_GET_PERF_COUNT
		./LU_CON -n128 -p$x; 
  		./DIRECTORY_GET_PERF_COUNT
		echo "End"
		#echo -n "$x" 
		j=$((j+1)); 
	done
	#echo "LU_CON -n128 -b$const -p2"
	j=0; while [ $j -le 5 ]; do 
		x=$const;
		echo "LU_CON -n128 -b$const -p2"
		echo "Start"
  		./DIRECTORY_GET_PERF_COUNT
		./LU_CON -n128 -b$x -p2; 
  		./DIRECTORY_GET_PERF_COUNT
		echo "End"
		#echo -n "$x" 
		j=$((j+1)); 
	done
	const=$((const * 2));
	i=$((i+1)); 
done

const=2

echo "Running LU Non Contiguous test."
i=0; while [ $i -le 5 ]; do 
	#echo "LU_NON_CON -n128 -p$const"
	j=0; while [ $j -le 5 ]; do 
		x=$const;
		echo "LU_NON_CON -n128 -p$const"
		echo "Start"
  		./DIRECTORY_GET_PERF_COUNT
		./LU_NON_CON -n128 -p$x; 
  		./DIRECTORY_GET_PERF_COUNT
		echo "End"
		#echo -n "$x" 
		j=$((j+1)); 
	done
	#echo "LU_NON_CON -n128 -b$const -p2"
	j=0; while [ $j -le 5 ]; do 
		x=$const;
		echo "LU_NON_CON -n128 -b$const -p2"
		echo "Start"
  		./DIRECTORY_GET_PERF_COUNT
		./LU_NON_CON -n128 -b$x -p2; 
  		./DIRECTORY_GET_PERF_COUNT
		echo "End"
		#echo -n "$x" 
		j=$((j+1)); 
	done
	const=$((const * 2));
	i=$((i+1));
done

:'
echo "Running WATER Nsquared test."
i=0; while [ $i -le 12 ]; do ./WATER-NSQUARED < input_water_2core; i=$((i+1)); done

echo "Running WATER Sequential test."
i=0; while [ $i -le 12 ]; do ./WATER-SPATIAL < input_water_2core; i=$((i+1)); done
'

const=2

echo "Running RADIX test."
i=0; while [ $i -le 5 ]; do 
	j=0; while [ $j -le 5 ]; do 
		x=$const;
		echo "RADIX -p$const"
		echo "Start"
  		./DIRECTORY_GET_PERF_COUNT
		./RADIX -p$x; 
  		./DIRECTORY_GET_PERF_COUNT
		echo "End"
		j=$((j+1)); 
	done
	const=$((const * 2));
	i=$((i+1));
done

const=2

echo "Running FFT easy test."
i=0; while [ $i -le 5 ]; do 
	j=0; while [ $j -le 5 ]; do 
		x=$const;
		echo "FFT -p$const"
		echo "Start"
  		./DIRECTORY_GET_PERF_COUNT
		./FFT -p$x; 
  		./DIRECTORY_GET_PERF_COUNT
		echo "End"
		j=$((j+1)); 
	done
	const=$((const * 2));
	i=$((i+1));
done

:'
echo "Running FMM 256 test."
i=0; while [ $i -le 12 ]; do ./FMM < input.256; i=$((i+1)); done

echo "Running FMM 2048 test."
i=0; while [ $i -le 12 ]; do ./FMM < input.2048; i=$((i+1)); done
'

const=2

echo "Running Ocean Contiguous test."
i=0; while [ $i -le 5 ]; do 
	j=0; while [ $j -le 5 ]; do 
		x=$const;
		echo "OCEAN_CON -n66 -p$const"
		echo "Start"
  		./DIRECTORY_GET_PERF_COUNT
		./OCEAN_CON -n66 -p$x; 
  		./DIRECTORY_GET_PERF_COUNT
		echo "End"
		j=$((j+1)); 
	done
	const=$((const * 2));
	i=$((i+1));
done

const=2

echo "Running Ocean Non Contiguous test."
i=0; while [ $i -le 5 ]; do 
	j=0; while [ $j -le 5 ]; do 
		x=$const;
		echo "OCEAN_NON_CON -n66 -p$const"
		echo "Start"
  		./DIRECTORY_GET_PERF_COUNT
		./OCEAN_NON_CON -n66 -p$x; 
  		./DIRECTORY_GET_PERF_COUNT
		echo "End"
		j=$((j+1)); 
	done
	const=$((const * 2));
	i=$((i+1));
done


exit 0
