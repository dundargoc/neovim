FROM ubuntu:latest
ARG TAG

COPY . /app
WORKDIR app
RUN apt-get update -y && apt-get install -y sudo libfuse2
RUN modprobe fuse
RUN .github/scripts/install_deps.sh

RUN ./scripts/genappimage.sh nightly
