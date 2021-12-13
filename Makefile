#!/bin/bash
# 
#                      @file    make_MC-GPU_v1.3.sh
#                      @author  Andreu Badal [Andreu.Badal-Soler(at)fda.hhs.gov]
#                      @date    2012/12/12
#   
# -- Compile GPU code for compute capability 1.3 and 2.0, with MPI:

# Default paths:
CUDA = /usr/local/cuda
CUDASDK = $(CUDA)/samples

TARGET 	= MC-GPU_v1.3.x
CC 		= $(CUDA)/bin/nvcc
CFLAGS 	= -m64 -O3 -use_fast_math
# If use CUDA, uncomment this
CFLAGS += -DUSING_CUDA
# If use MPI, uncomment this
# CFLAGS += -DUSING_MPI 

CFLAGS += --ptxas-options=-v -gencode=arch=compute_61,code=sm_61

SOURCE += MC-GPU_v1.3.cu
INCLUDE += -I. -I$(CUDA)/include -I$(CUDASDK)/common/inc -I$(CUDASDK)/shared/inc/ -I/usr/local/include

LIB += -L/usr/local/lib/ -lmpi -lz 


# Building the application:
$(TARGET) : $(SOURCE)
	$(CC) $^ -o $@ $(CFLAGS) $(INCLUDE) $(LIB)

.PHONY : clean
clean : 
	rm -rf $(TARGET)

#/usr/local/cuda/bin/nvcc MC-GPU_v1.3.cu -o MC-GPU_v1.3.x -m64 -O3 -use_fast_math -DUSING_CUDA -DUSING_MPI -I. -I/usr/local/cuda/include -I/usr/local/cuda/samples/common/inc -I/usr/local/cuda/samples/shared/inc/ -I/usr/local/include -L/usr/local/lib/ -lmpi -lz --ptxas-options=-v -gencode=arch=compute_61,code=sm_61

# -- CPU compilation:
 
# ** GCC (with MPI):
# gcc -x c -DUSING_MPI MC-GPU_v1.3.cu -o MC-GPU_v1.3_gcc_MPI.x -Wall -O3 -ffast-math -ftree-vectorize -ftree-vectorizer-verbose=1 -funroll-loops -static-libgcc -I./ -lm -I/usr/include/openmpi -I/usr/lib/openmpi/include/openmpi/ -L/usr/lib/openmpi/lib -lmpi

     
# ** Intel compiler (with MPI):
# icc -x c -O3 -ipo -no-prec-div -msse4.2 -parallel -Wall -DUSING_MPI MC-GPU_v1.3.cu -o MC-GPU_v1.3_icc_MPI.x -I./ -lm -I/usr/include/openmpi -L/usr/lib/openmpi/lib/ -lmpi


# ** PGI compiler:
# pgcc -fast,sse -O3 -Mipa=fast -Minfo -csuffix=cu -Mconcur MC-GPU_v1.3.cu -I./ -lm -o MC-GPU_v1.3_PGI.x

