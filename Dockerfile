FROM fpco/stack-build:lts-16.8 as build
RUN mkdir -p /opt/build
COPY . /opt/build
RUN cd /opt/build && stack setup && stack build --system-ghc && mv "$(stack path --local-install-root --system-ghc)/bin" /opt/build/bin


FROM ubuntu:18.04
RUN mkdir -p /opt/myapp
ARG BINARY_PATH
WORKDIR /opt/myapp
RUN apt-get update && apt-get install -y \
  ca-certificates \
    libgmp-dev

COPY --from=build /opt/build/bin  .

CMD ["/opt/myapp/smared-exe"] 
EXPOSE 50000
