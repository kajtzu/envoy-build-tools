#!/bin/bash

set -e
ARCH="$(uname -m)"

# ninja-build comes from here
dnf config-manager --set-enabled crb

# install compilers

#yum install -y devtoolset-9-gcc devtoolset-9-gcc-c++ devtoolset-9-binutils java-1.8.0-openjdk-headless jq rsync \
#    rh-git218 wget unzip which make cmake3 patch ninja-build devtoolset-9-libatomic-devel openssl python27 \
#    libtool autoconf tcpdump graphviz doxygen sudo glibc-static libstdc++-static

yum install -y gcc-c++ clang libstdcc++-static cmake unzip rsync wget patch libtool autoconf doxygen tcpdump sudo glibc-static
yum install -y ninja-build 
yum update -y

# install bazel
wget -O /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-$([ $(uname -m) = "aarch64" ] && echo "arm64" || echo "amd64")
sudo chmod +x /usr/local/bin/bazel

# set locale
localedef -c -f UTF-8 -i en_US en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Setup tcpdump for non-root.
groupadd -r pcap
chgrp pcap /usr/sbin/tcpdump
chmod 750 /usr/sbin/tcpdump
setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump

# full of weird stuff need to look at it closer
# 
# source ./build_container_common.sh

#git clone https://gn.googlesource.com/gn
#pushd gn
# 45aa842fb41d79e149b46fac8ad71728856e15b9 is a hash of the version
# before https://gn.googlesource.com/gn/+/46b572ce4ceedfe57f4f84051bd7da624c98bf01
# as this commit expects envoy to rely on newer version of wasm/v8 with the fix
# from https://github.com/v8/v8/commit/eac21d572e92a82f5656379bc90f8ecf1ff884fc
# (versions 9.5.164 - 9.6.152)
#git checkout 45aa842fb41d79e149b46fac8ad71728856e15b9
#python build/gen.py
#ninja -C out
#mv -f out/gn /usr/local/bin/gn
#chmod +x /usr/local/bin/gn
#popd

yum clean all
