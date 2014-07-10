#!/bin/sh

cd PRoot
make -C src
make -C tests V=1
cd ..
