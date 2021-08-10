#!/bin/bash
# Build all rootfs (amd64, i386, arm64, armhf)

# Author: Luca Fabbian <luca.fabbian.1999@gmail.com>
# License: MIT
cd "$(dirname "${BASH_SOURCE[0]}")"
export BDIR=`realpath .`
export REPO="https://unyw.github.io/repo-main"

# Clean old dist and download repositories' keys
rm -rf 'dist' && mkdir 'dist'


buildRootfs(){
  cd "$BDIR"
  echo "BUILDING arch $1
--> cloning minimal rootfs
"
  # Create container and get rootfs
  rm -rf '.tmp/rootfs' && mkdir -p .tmp/rootfs
  cd .tmp/rootfs
  wget "https://dl-cdn.alpinelinux.org/alpine/v3.14/releases/$1/alpine-minirootfs-3.14.1-$1.tar.gz" -O - | tar -xz

  echo "
--> installing repos and packages
"
  echo "$REPO/stable" >> etc/apk/repositories
  #echo "https://unyw.github.io/repo-main/stable" >> etc/apk/repositories
  
  # AGGIUNGI QUI LE CHIAVI
  wget -P etc/apk/keys "$REPO/unyw@key.rsa.pub"
  proot $PROOT_ARGS -S . -w / apk add --no-cache --virtual unyw unyw-bridge-android
  proot $PROOT_ARGS -S . -w / apk add --no-cache xterm unyw-app-xterm unyw-app-home


  echo '
  --> Creating archive and checksum'
  # Compress to tar.xz
  cd ../
  rm -f "../dist/rootfs_$1.tar.xz"
  tar -cJf "../dist/rootfs_$1.tar.xz" rootfs

  # Generating md5sum
  md5sum "../dist/rootfs_$1.tar.xz" |cut -f 1 -d " " > "../dist/rootfs_$1.tar.xz.md5"
}




# Build x64, x32, arm64, arm32
buildRootfs x86_64
buildRootfs x86
PROOT_ARGS="-q qemu-aarch64-static" buildRootfs aarch64
PROOT_ARGS="-q qemu-arm-static" buildRootfs armv7
