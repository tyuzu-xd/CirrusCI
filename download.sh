#!/usr/bin/env bash

echo "Downloading few Dependecies . . ."
# Kernel Sources
git clone --depth 1 https://github.com/trinket-devs/kernel_xiaomi_ginkgo.git -b 11.0 $CIRRUS_WORKING_DIR/$DEVICE_CODENAME
# Toolchain
# git clone --depth 1 https://github.com/mvaisakh/gcc-arm.git -b gcc-master $CIRRUS_WORKING_DIR/GCC-11-32
# git clone --depth 1 https://github.com/mvaisakh/gcc-arm64.git -b gcc-master $CIRRUS_WORKING_DIR/GCC-11-64
git clone --depth 1 https://github.com/ThankYouMario/proprietary_vendor_qcom_sdclang.git -b 14 $CIRRUS_WORKING_DIR/CLANG
git clone --depth 1 https://github.com/tyuzu-xd/AnyKernel3.git -b ginkgo $CIRRUS_WORKING_DIR/AnyKernel