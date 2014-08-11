#!/bin/sh

# For chroot and some other programs
export PATH=$PATH:/sbin:/usr/sbin

# Make and test PRoot
cd PRoot
git checkout next
make -C src
make -C tests V=1
cd ..
