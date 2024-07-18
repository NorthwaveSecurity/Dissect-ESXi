# Dissect ESXi

Code related to building a Dissect Acquire (or any other Dissect tool) which can run on ESXi. 

The main problem it solves is that `/proc/self/exe` is not available on ESXi. The code creates a patched version of Rust which uses `argv[0]` as source to determine the current executable instead. This can be executed by running `build_rust.sh`

Furthermore the `build_dissect.sh` generates an acquire, target-query and target-shell binary. This is done by configuring PyOxidizer to install the needed dissect dependencies. This is based on the example configuration provided in the [dissect documentation](https://docs.dissect.tools/en/latest/tools/acquire.html#deployment).

Blog: <link>

Acquire: https://github.com/fox-it/acquire/

## Compilation
In order to build your custom Dissect binaries follow these steps. Be carefull, since this will build a custom rust environment on your system. If you are not sure if you want to do this follow the Docker approach.

1. Build Rust: `./build_rust.sh`
2. Build the Dissect binaries `./build-dissect.sh`
3. Now you have the Dissect binaries in `/opt/dissect/`


## Compilation - Docker
If you don't want to build a custom Rust version on your own machine.

1. `docker build -t dissect-esxi .`
2. `docker run -it --name dissect dissect-esxi`
3. In another shell `docker cp dissect:/opt/dissect/ .`


## Usage
Now you have the dissect binaries you can compy them to your target ESXi machine (for example through SCP). Now you can use dissect according to the documentation.