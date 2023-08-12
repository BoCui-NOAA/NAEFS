SHELL=/bin/sh
#set -x

  module purge
  module load envvar/1.0
  module load PrgEnv-intel/8.1.0
  module load craype/2.7.8
  module load intel/19.1.3.304
  module load bacio/2.4.1
  module load w3nco/2.4.1
  module load sp/2.3.3
  module load ip/3.3.3

  export FCMP=ftn

export LIBS="${IP_LIB4} \
              ${SP_LIB4} \
              ${W3NCO_LIB4} \
              ${BACIO_LIB4}"

make -f makefile_0.5d_qpf
make -f makefile_1deg_qpf
make -f makefile_1deg_qpf_00_00
make -f makefile_1deg_qpf_21mctl
make -f makefile_1deg_qpf_ctl


