#!/usr/bin/env bash

echo "Downloading few Dependecies . . ."
# Kernel Sources
git clone --depth=1 https://github.com/kutemeikito/android_kernel_xiaomi_ginkgo.git -b MiuiR-WIP $CIRRUS_WORKING_DIR/$DEVICE_CODENAME
# Toolchain
#git clone --depth 1 https://github.com/sohamxda7/llvm-stable.git -b gcc32 $CIRRUS_WORKING_DIR/GCC-11-32
#git clone --depth 1 https://github.com/sohamxda7/llvm-stable.git -b gcc64 $CIRRUS_WORKING_DIR/GCC-11-64
git clone --depth=1 https://github.com/kdrag0n/proton-clang.git $CIRRUS_WORKING_DIR/CLANG
git clone --depth=1 https://github.com/tyuzu-xd/AnyKernel3.git -b ginkgo $CIRRUS_WORKING_DIR/AnyKernel
