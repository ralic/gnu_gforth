# First create a standalone toolchain directory
#mkdir ~/proj/android-toolchain
#cd  ~/proj/android-toolchain
#~/proj/android-ndk-r6b/build/tools/make-standalone-toolchain.sh --platform=android-5 --ndk-dir=/home/bernd/proj/android-ndk-r6b --install-dir=$PWD
ar x ~/proj/android-toolchain/sysroot/usr/lib/libc.a engine/sigaltstack.o
skipcode=".skip 4\n.skip 4\n.skip 4\n.skip 4"
kernel_fi=kernl64l.fi
ac_cv_sizeof_void_p=4
ac_cv_sizeof_char_p=4
ac_cv_sizeof_char=1
ac_cv_sizeof_short=2
ac_cv_sizeof_int=4
ac_cv_sizeof_long=4
ac_cv_sizeof_long_long=8
ac_cv_sizeof_intptr_t=4
ac_cv_sizeof_int128_t=0
ac_cv_c_bigendian=no
ac_cv_func_memcmp_working=yes
ac_cv_file___arch_arm_asm_fs=no
ac_cv_file___arch_arm_disasm_fs=no
CC=arm-linux-androideabi-gcc
asm_fs=arch/arm/asm.fs
disasm_fs=
EC_MODE="false"
NO_EC=""
EC=""
engine2='engine2$(OPT).o'
engine_fast2='engine-fast2$(OPT).o'
no_dynamic=""
image_i=""
signals_o="io.o signals.o sigaltstack.o"
