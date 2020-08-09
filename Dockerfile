FROM fpco/stack-build:lts-16.8 as build
RUN mkdir /opt/build
COPY . /opt/build
RUN cd /opt/build && stack build --system-ghc
FROM ubuntu:16.04
RUN apt-get update && apt-get install -y \
  ca-certificates \
    libgmp-dev

ENTRYPOINT stack run

EXPOSE 50000
