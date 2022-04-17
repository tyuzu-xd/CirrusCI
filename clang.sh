#!/usr/bin/env bash
    
# Main Declaration
function env() {
DEFCONFIG=vendor/ginkgo-perf_defconfig
KERNEL_ROOTDIR=$CIRRUS_WORKING_DIR/$DEVICE_CODENAME
CLANG_ROOTDIR=$CIRRUS_WORKING_DIR/CLANG
CLANG_VER="$("$CLANG_ROOTDIR"/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')"
LLD_VER="$("$CLANG_ROOTDIR"/bin/ld.lld --version | head -n 1)"
IMAGE=$CIRRUS_WORKING_DIR/$DEVICE_CODENAME/out/arch/arm64/boot/Image.gz-dtb
DTBO=$CIRRUS_WORKING_DIR/$DEVICE_CODENAME/out/arch/arm64/boot/dtbo.img
DATE=$(date +"%F-%S")
START=$(date +"%s")
export KERNEL_NAME=FanEdition-Kernel-CLANG
export KBUILD_BUILD_USER=$BUILD_USER
export KBUILD_BUILD_HOST=$BUILD_HOST
export KBUILD_COMPILER_STRING="$CLANG_VER"
export BOT_MSG_URL="https://api.telegram.org/bot$TG_TOKEN/sendMessage"
export BOT_MSG_URL2="https://api.telegram.org/bot$TG_TOKEN"
}
# Checking environtment
# Warning !! Dont Change anything there without known reason.
function check() {
echo BUILDER NAME = ${KBUILD_BUILD_USER}
echo BUILDER HOSTNAME = ${KBUILD_BUILD_HOST}
echo DEFCONFIG = ${DEFCONFIG}
echo TOOLCHAIN_VERSION = ${KBUILD_COMPILER_STRING}
echo CLANG_ROOTDIR = ${CLANG_ROOTDIR}
echo KERNEL_ROOTDIR = ${KERNEL_ROOTDIR}
echo ================================================
}
tg_post_msg() {
  curl -s -X POST "$BOT_MSG_URL" -d chat_id="$TG_CHAT_ID" \
  -d "disable_web_page_preview=true" \
  -d "parse_mode=html" \
  -d text="$1"
}
# Compile
compile(){
cd ${KERNEL_ROOTDIR}
tg_post_msg "<b>Buiild Kernel Clang started..</b>"
    make -j$(nproc --all) O=out ARCH=arm64 SUBARCH=arm64 ${DEFCONFIG}
    make -j$(nproc --all) ARCH=arm64 SUBARCH=arm64 O=out \
	CC=${CLANG_ROOTDIR}/bin/clang \
    NM=${CLANG_ROOTDIR}/bin/llvm-nm \
    AR=${CLANG_ROOTDIR}/bin/llvm-ar \
    AS=${CLANG_ROOTDIR}/bin/llvm-as \
    OBJCOPY=${CLANG_ROOTDIR}/bin/llvm-objcopy \
    OBJDUMP=${CLANG_ROOTDIR}/bin/llvm-objdump \
    STRIP=${CLANG_ROOTDIR}/bin/llvm-strip \
    CROSS_COMPILE=${CLANG_ROOTDIR}/bin/aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=${CLANG_ROOTDIR}/bin/arm-linux-gnueabi-
   if ! [ -a "$IMAGE" ]; then
	finerr
   fi
	git clone --depth=1 $ANYKERNEL $CIRRUS_WORKING_DIR/AnyKernel
	cp $IMAGE $CIRRUS_WORKING_DIR/AnyKernel
    cp $DTBO $CIRRUS_WORKING_DIR/AnyKernel
}
# Push kernel to channel
function push() {
    cd $CIRRUS_WORKING_DIR/AnyKernel
    zip -r9 $KERNEL_NAME-$DEVICE_CODENAME-${DATE}.zip *
    ZIP=$(echo *.zip)
    curl -F document=@$ZIP "https://api.telegram.org/bot$TG_TOKEN/sendDocument" \
        -F chat_id="$TG_CHAT_ID" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" \
        -F caption="$KERNEL_NAME
==========================
👤 Owner: tyuzu-xd
🏚️ Linux version: $KERNEL_VERSION
🌿 Branch: $BRANCH
🎁 Top commit: $LATEST_COMMIT
👩‍💻 Commit author: $COMMIT_BY
🐧 UTS version: $UTS_VERSION
💡 Compiler: $TOOLCHAIN_VERSION
==========================
Compile took $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s)."
}
# Fin Error
function finerr() {
    curl -s -X POST "$BOT_MSG_URL" -d chat_id="$TG_CHAT_ID" \
	    -d "disable_web_page_preview=true" \
	    -d "parse_mode=html" \
        -d text="==============================%0A<b>    Building Kernel CLANG Failed [❌]</b>%0A==============================" \
    exit 1
}

function info() {
cd $KERNEL_ROOTDIR
KERNEL_VERSION=$(cat $KERNEL_ROOTDIR/out/.config | grep Linux/arm64 | cut -d " " -f3)
UTS_VERSION=$(cat $KERNEL_ROOTDIR/out/include/generated/compile.h | grep UTS_VERSION | cut -d '"' -f2)
TOOLCHAIN_VERSION=$(cat $KERNEL_ROOTDIR/out/include/generated/compile.h | grep LINUX_COMPILER | cut -d '"' -f2)
TRIGGER_SHA="$(git rev-parse HEAD)"
LATEST_COMMIT="$(git log --pretty=format:'%s' -1)"
COMMIT_BY="$(git log --pretty=format:'by %an' -1)"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"

}

env
check
compile
END=$(date +"%s")
DIFF=$(($END - $START))
info
push
