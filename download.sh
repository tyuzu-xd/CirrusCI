#!/usr/bin/env bash

echo "Downloading few Dependecies . . ."
# Kernel Sources
git clone --depth 1 https://github.com/tyuzu-xd/kernel_xiaomi_ginkgo.git -b elainaX-11 $CIRRUS_WORKING_DIR/$DEVICE_CODENAME
# Toolchain
git clone --depth 1 https://github.com/kdrag0n/proton-clang.git $CIRRUS_WORKING_DIR/CLANG
git clone --depth 1 https://github.com/tyuzu-xd/AnyKernel3.git -b Ginkgo $CIRRUS_WORKING_DIR/AnyKernel