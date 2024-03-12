FROM debian:bookworm-20240311-slim@sha256:ccb33c3ac5b02588fc1d9e4fc09b952e433d0c54d8618d0ee1afadf1f3cf2455

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH

# renovate: datasource=github-tags depName=yfhme/y-cs-firewall-bouncer
ENV FW_BOUNCER_VERSION=v0.0.29-rc1c
ENV BOUNCER_URL=https://github.com/yfhme/y-cs-firewall-bouncer/releases/download/$FW_BOUNCER_VERSION/crowdsec-firewall-bouncer-linux-$TARGETARCH.tgz 

ADD ${BOUNCER_URL} /tmp/src/

WORKDIR /tmp/src

RUN set -x && \
  apt-get update && \
  apt-get purge -y --auto-remove nftables && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
  gettext \
  ipset \
  iptables && \
  tar xzvf crowdsec-firewall-bouncer-linux-$TARGETARCH.tgz && \
  rm -f crowdsec-firewall-bouncer-linux-$TARGETARCH.tgz && \
  cd crowdsec-firewall-bouncer-$FW_BOUNCER_VERSION && \
  ./install-docker.sh && \
  apt-get purge -y --auto-remove && \
  rm -rf \
  /usr/local/go \
  /tmp/* \
  /var/tmp/* \
  /var/lib/apt/lists/*

ENTRYPOINT crowdsec-firewall-bouncer -c /crowdsec-firewall-bouncer.yaml
