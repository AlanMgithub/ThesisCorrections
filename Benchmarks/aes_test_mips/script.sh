#!/bin/sh
export PATH=$PATH:/mnt
clear 

echo "Running GCC1 + MEM"
i=0; while [ $i -le 100 ]; do
  #./LU_CON -p2; i=$((i+1)); 
  ./CLANG1_MIPS_AES_256 & ./TEST_MEM_LINE >> test_aes_data_1.txt;
  i=$((i+1));
done

echo "Running GCC2 + MEM"
i=0; while [ $i -le 100 ]; do
  #./LU_NON_CON -p2; i=$((i+1)); 
  ./CLANG2_MIPS_AES_256 & ./TEST_MEM_LINE >> test_aes_data_2.txt;
  i=$((i+1));
done

exit 0
