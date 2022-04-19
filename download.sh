#!/usr/bin/env bash

echo "Downloading few Dependecies . . ."
# Kernel Sources
git clone --depth=1 https://github.com/tzuyu-xd/android_kernel_xiaomi_ginkgo.git -b MiuiQ $CIRRUS_WORKING_DIR/$DEVICE_CODENAME
# Toolchain
#git clone --depth 1 https://github.com/sohamxda7/llvm-stable.git -b gcc32 $CIRRUS_WORKING_DIR/GCC-11-32
#git clone --depth 1 https://github.com/sohamxda7/llvm-stable.git -b gcc64 $CIRRUS_WORKING_DIR/GCC-11-64
git clone --depth=1 https://github.com/ZyCromerZ/SDClang.git -b 14 $CIRRUS_WORKING_DIR/CLANG
git clone --depth=1 https://github.com/tyuzu-xd/AnyKernel3.git -b ginkgo $CIRRUS_WORKING_DIR/AnyKernel
