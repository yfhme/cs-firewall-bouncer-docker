FROM debian:bookworm-20231218-slim@sha256:f80c45482c8d147da87613cb6878a7238b8642bcc24fc11bad78c7bec726f340

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH

# renovate: datasource=github-tags depName=yfhme/y-cs-firewall-bouncer
ENV FW_BOUNCER_VERSION=v0.0.29-rc1
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
