#!/usr/bin/env bash

echo "Downloading few Dependecies . . ."
# Kernel Sources
git clone --depth=1 https://github.com/tyuzu-xd/kernel_xiaomi_ginkgo.git -b elainaX-11 $CIRRUS_WORKING_DIR/$DEVICE_CODENAME
# Toolchain
git clone --depth 1 https://github.com/ImSpiDy/gcc-9.3.0.git -b gcc32 $CIRRUS_WORKING_DIR/GCC-11-32
git clone --depth 1 https://github.com/ImSpiDy/gcc-9.3.0.git -b gcc64 $CIRRUS_WORKING_DIR/GCC-11-64
#git clone --depth=1 https://gitlab.com/ElectroPerf/atom-x-clang.git -b atom-15 $CIRRUS_WORKING_DIR/CLANG
git clone --depth=1 https://github.com/tyuzu-xd/AnyKernel3.git -b ginkgo $CIRRUS_WORKING_DIR/AnyKernel
