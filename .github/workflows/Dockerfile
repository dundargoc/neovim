FROM ubuntu:latest as builder
ARG TAG

COPY . /app
WORKDIR app
RUN apt-get update -y
RUN apt-get install -y sudo
RUN .github/scripts/install_deps.sh

# RUN apt-get update && apt-get install -y git
# RUN git clone --depth=1 https://github.com/neovim/neovim.git home/neovim
# RUN git clone --depth=1 https://github.com/dundargoc/neovim.git home/neovim
# WORKDIR home/neovim
# RUN git fetch origin ${TAG}:pr
# RUN git switch pr

RUN touch flerp
