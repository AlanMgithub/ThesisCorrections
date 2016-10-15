#!/bin/sh
export PATH=$PATH:/mnt
clear 

n=32

p=0; while [ $p -le 3 ]; do 
	const=2
	i=0; while [ $i -le 5 ]; do 
		j=0; while [ $j -le 5 ]; do 
			x=$const;
			echo "LU_CON -n$n -p$const"
			./LU_CON -n$n -p$x; 
			j=$((j+1)); 
		done
		const=$((const * 2));
		i=$((i+1)); 
	done
	n=$((n * 2));
	p=$((p+1)); 
done

n=32

p=0; while [ $p -le 3 ]; do 
	const=2
	i=0; while [ $i -le 5 ]; do 
		j=0; while [ $j -le 5 ]; do 
			x=$const;
			echo "LU_NON_CON -n$n -p$const"
			./LU_NON_CON -n$n -p$x; 
			j=$((j+1)); 
		done
		const=$((const * 2));
		i=$((i+1));
	done
	n=$((n * 2));
	p=$((p+1)); 
done


n=128

p=0; while [ $p -le 3 ]; do 
	const=2
	i=0; while [ $i -le 5 ]; do 
		j=0; while [ $j -le 5 ]; do 
			x=$const;
			echo "RADIX -r$n -p$const"
			./RADIX -r$n -p$x; 
			j=$((j+1)); 
		done
		const=$((const * 2));
		i=$((i+1));
	done
	n=$((n * 2));
	p=$((p+1)); 
done


n=8
v=10

p=0; while [ $p -le 3 ]; do 
	const=2
	i=0; while [ $i -le 5 ]; do 
		j=0; while [ $j -le 5 ]; do 
			x=$const;
			echo "OCEAN_CON -n$v -p$const"
			./OCEAN_CON -n$v -p$x; 
			j=$((j+1)); 
		done
		const=$((const * 2));
		i=$((i+1));
	done
	n=$((n * 2));
	v=$((n + 2));
	p=$((p+1)); 
done


n=8
v=10

p=0; while [ $p -le 3 ]; do 
	const=2
	i=0; while [ $i -le 5 ]; do 
		j=0; while [ $j -le 5 ]; do 
			x=$const;
			echo "OCEAN_NON_CON -n$v -p$const"
			./OCEAN_NON_CON -n$v -p$x; 
			j=$((j+1)); 
		done
		const=$((const * 2));
		i=$((i+1));
	done
	n=$((n * 2));
	v=$((n + 2));
	p=$((p+1)); 
done



exit 0
