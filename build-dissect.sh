#!/bin/sh -ex

pip install pyoxidizer==0.23.0
pyoxidizer init-config-file dissect-build
cd dissect-build

# We need to generate a pluginlist, as dynamics loading does not work with PyOxidizer
git clone https://github.com/fox-it/dissect.target.git
cd dissect.target
pip install dissect
pip install .
python3 -m dissect.target.tools.build_pluginlist > dissect/target/plugins/_pluginlist.py
cd ..

# Configure PyOxidizer
sed -i 's/# policy.resources_location_fallback = "filesystem-relative:prefix"/policy.resources_location_fallback = "filesystem-relative:prefix"/' pyoxidizer.bzl
sed -i 's/# python_config.run_module = "<module>"/python_config.run_module = "acquire.acquire"/' pyoxidizer.bzl
sed -i 's/#exe.add_python_.*pyflakes.*/exe.add_python_resources(exe.pip_install([".\/dissect.target", "dissect.sql", "dissect.vmfs", "dissect.extfs", "dissect.fat", "dissect.btrfs", "dissect.ffs", "dissect.squashfs", "dissect.xfs", "acquire"]))/' pyoxidizer.bzl

mkdir /opt/dissect/

# Compile Acquire
export MSGPACK_PUREPYTHON=1
pyoxidizer build --target-triple x86_64-unknown-linux-musl --system-rust
cp build/x86_64-unknown-linux-musl/debug/install/dissect-build /opt/dissect/dissect-acquire

# Compile target-query
sed -i 's/python_config.run_module = "acquire.acquire"/python_config.run_module = "dissect.target.tools.query"/' pyoxidizer.bzl
pyoxidizer build --target-triple x86_64-unknown-linux-musl --system-rust
cp build/x86_64-unknown-linux-musl/debug/install/dissect-build /opt/dissect/dissect-target-query

# Compile target-shell
sed -i 's/python_config.run_module = "dissect.target.tools.query"/python_config.run_module = "dissect.target.tools.shell"/' pyoxidizer.bzl
pyoxidizer build --target-triple x86_64-unknown-linux-musl --system-rust
cp build/x86_64-unknown-linux-musl/debug/install/dissect-build /opt/dissect/dissect-target-shell
