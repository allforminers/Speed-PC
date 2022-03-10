#!/bin/bash

# Working setup to cross-compile Windows binaries for Qt Coin hosted on a
# Ubuntu 16.04 box using non-Canonical ppas for MXE and Qt5.7:
# deb http://pkg.mxe.cc/repos/apt/debian wheezy main

# Doesn't seem to pass the QT directives through, though.

# Basic path bindings

PATH=/mnt/mxe/usr/bin:$PATH
MXE_PATH=/mnt/mxe
MXE_INCLUDE_PATH=/mnt/mxe/usr/i686-w64-mingw32.static/include
MXE_LIB_PATH=/mnt/mxe/usr/i686-w64-mingw32.static/lib

# Belt and braces

CXXFLAGS="-std=gnu++11 -march=i686"
LDFLAGS="-march=i686"
target="i686-w64-mingw32.static"

# Particulars for cross-compiling

export BOOST_LIB_SUFFIX=-mt
export BOOST_THREAD_LIB_SUFFIX=_win32-mt
export BOOST_INCLUDE_PATH=${MXE_INCLUDE_PATH}/boost
export BOOST_LIB_PATH=${MXE_LIB_PATH}
export OPENSSL_INCLUDE_PATH=${MXE_INCLUDE_PATH}/openssl
export OPENSSL_LIB_PATH=${MXE_INCLUDE_PATH}/openssl/lib
export BDB_INCLUDE_PATH=${MXE_INCLUDE_PATH}
export BDB_LIB_PATH=${MXE_LIB_PATH}
export MINIUPNPC_INCLUDE_PATH=${MXE_INCLUDE_PATH}
export MINIUPNPC_LIB_PATH=${MXE_INCLUDE_LIB}
export MINIUPNP_STATICLIB=${MXE_INCLUDE_LIB}
export QRENCODE_INCLUDE_PATH=/mnt/mxe/qrencode/install/include
export QRENCODE_LIB_PATH=/mnt/mxe/qrencode/install/lib
export SECP256K1_LIB_PATH=/home/ader/coins/AmsterdamCoin/src/secp256k1/libs
export SECP256K1_INCLUDE_PATH=/home/ader/coins/AmsterdamCoin/src/secp256k1/include
export QMAKE_LRELEASE=${MXE_PATH}/usr/${target}/qt5/bin/lrelease

# Call qmake to create Makefile.[Release|Debug]

${target}-qmake-qt5 \
    MXE=1 \
    USE_O3=1 \
    USE_QRCODE=1 \
    FIRST_CLASS_MESSAGING=1 \
    RELEASE=1 \
    O3=1 \
    USE_QRCODE=1 \
    FIRST_CLASS_MESSAGING=1 \
    RELEASE=1 \
    USE_UPNPC=1 \
    BOOST_LIB_SUFFIX=${BOOST_LIB_SUFFIX} \
    BOOST_THREAD_LIB_SUFFIX=${BOOST_THREAD_LIB_SUFFIX} \
    BOOST_INCLUDE_PATH=${BOOST_INCLUDE_PATH} \
    BOOST_LIB_PATH=${BOOST_LIB_PATH} \
    OPENSSL_INCLUDE_PATH=${OPENSSL_INCLUDE_PATH} \
    OPENSSL_LIB_PATH=${OPENSSL_LIB_PATH} \
    BDB_INCLUDE_PATH=${BDB_INCLUDE_PATH} \
    BDB_LIB_PATH=${BDB_LIB_PATH} \
    MINIUPNPC_INCLUDE_PATH=${MINIUPNPC_INCLUDE_PATH} \
    MINIUPNPC_LIB_PATH=${MINIUPNPC_LIB_PATH} \
    MINIUPNP_STATICLIB=${MINIUPNP_STATICLIB} \
    QRENCODE_INCLUDE_PATH=/mnt/mxe/qrencode/install/include \
    QRENCODE_LIB_PATH=/mnt/mxe/qrencode/install/lib \
    QMAKE_LRELEASE=${QMAKE_LRELEASE} WideCash-qt.pro
    SECP256K1_LIB_PATH=/home/ader/coins/DEPS/src/secp256k1/.libs \
    SECP256K1_INCLUDE_PATH=/home/ader/coins/DEPS/src/secp256k1/include \

# Go for it. If successful, Windows binary will be written out to ./release/COin-name-qt.exe
cd src/leveldb
TARGET_OS=NATIVE_WINDOWS make libleveldb.a libmemenv.a CC=/mnt/mxe/usr/bin/i686-w64-mingw32.static-gcc CXX=/mnt/mxe/usr/bin/i686-w64-mingw32.static-g++

make -f Makefile.Release