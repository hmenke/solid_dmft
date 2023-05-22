# Default precompiler options
CPP_OPTIONS = -DHOST=\"LinuxGNU\" \
              -DMPI -DMPI_BLOCK=8000 -Duse_collective \
              -DscaLAPACK \
              -DCACHE_SIZE=4000 \
              -Davoidalloc \
              -Dvasp6 \
              -Duse_bse_te \
              -Dtbdyn \
              -Dfock_dblbuf \
              -D_OPENMP

CPP         = gcc -E -C -w $*$(FUFFIX) >$*$(SUFFIX) $(CPP_OPTIONS)

FC          = mpif90 -fopenmp
FCL         = mpif90 -fopenmp

FREE        = -ffree-form -ffree-line-length-none

FFLAGS      = -w -ffpe-summary=none

OFLAG       = -O2
OFLAG_IN    = $(OFLAG)
DEBUG       = -O0

OBJECTS     = fftmpiw.o fftmpi_map.o fftw3d.o fft3dlib.o
OBJECTS_O1 += fftw3d.o fftmpi.o fftmpiw.o
OBJECTS_O2 += fft3dlib.o

# For what used to be vasp.5.lib
CPP_LIB     = $(CPP)
FC_LIB      = $(FC)
CC_LIB      = gcc
CFLAGS_LIB  = -O
FFLAGS_LIB  = -O1
FREE_LIB    = $(FREE)

OBJECTS_LIB = linpack_double.o

# For the parser library
CXX_PARS    = g++
LLIBS       = -lstdc++

##
## Customize as of this point! Of course you may change the preceding
## part of this file as well if you like, but it should rarely be
## necessary ...
##

# When compiling on the target machine itself, change this to the
# relevant target when cross-compiling for another architecture
VASP_TARGET_CPU ?= -march=broadwell
FFLAGS     += $(VASP_TARGET_CPU)

# For gcc-10 and higher (comment out for older versions)
#FFLAGS     += -fallow-argument-mismatch

# Intel MKL for FFTW, BLAS, LAPACK, and scaLAPACK
#MKLROOT   ?= /path/to/your/mkl/installation
#LLIBS_MKL  = -L$(MKLROOT)/lib/intel64 -Wl,--no-as-needed -lmkl_gf_lp64 -lmkl_gnu_thread -lmkl_core -lmkl_scalapack_lp64 -lmkl_blacs_openmpi_lp64 -lgomp -lpthread -lm -ldl
INCS       = -I/usr/include/mkl/fftw

# Use a separate scaLAPACK installation (optional but recommended in combination with OpenMPI)
# Comment out the two lines below if you want to use scaLAPACK from MKL instead
LLIBS_MKL  = -lscalapack-openmpi -Wl,--no-as-needed -lmkl_gf_lp64 -lmkl_gnu_thread -lmkl_core -lgomp -lpthread -lm -ldl

LLIBS      += $(LLIBS_MKL)

# HDF5-support (optional but strongly recommended)
CPP_OPTIONS+= -DVASP_HDF5
LLIBS      += -lhdf5_serial_fortran
INCS       += -I/usr/include/hdf5/serial

# For the VASP-2-Wannier90 interface (optional)
CPP_OPTIONS    += -DVASP2WANNIER90
WANNIER90_ROOT ?= /usr
LLIBS          += -L$(WANNIER90_ROOT)/lib -lwannier

# For the fftlib library (hardly any benefit in combination with MKL's FFTs)
#CPP_OPTIONS+= -Dsysv
#FCL        += fftlib.o
#CXX_FFTLIB  = g++ -fopenmp -std=c++11 -DFFTLIB_USE_MKL -DFFTLIB_THREADSAFE
#INCS_FFTLIB = -I./include -I$(MKLROOT)/include/fftw
#LIBS       += fftlib
#LLIBS      += -ldl
