#!/bin/sh

cd PRoot
git checkout next
make -C src
make -C tests V=1
cd ..
