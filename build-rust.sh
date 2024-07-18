#!/bin/sh -ex
git clone --depth 1 --single-branch -b 1.68.0 https://github.com/rust-lang/rust.git
cd /rust
patch -Np1 < /tmp/esxi-compat.patch
cp /tmp/config.toml .
./x.py build library
./x.py install
cd /
rm -rf rust
