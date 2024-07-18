FROM debian
RUN apt update && apt install -y python3 pip musl-tools build-essential curl liblzma-dev cmake ninja-build vim git pkg-config libssl-dev

ENV PIP_BREAK_SYSTEM_PACKAGES=1

COPY . /tmp
RUN sh -ex /tmp/build-rust.sh
RUN sh -ex /tmp/build-dissect.sh