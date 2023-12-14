FROM debian:stable-slim

ARG DEBIAN_FRONTEND=noninteractive \
    TARGETARCH
# renovate: datasource=github-tags depName=yfhme/y-cs-firewall-bouncer
ENV FW_BOUNCER_VERSION=v0.0.29-rc0
ENV BOUNCER_URL=https://github.com/yfhme/y-cs-firewall-bouncer/releases/download/$FW_BOUNCER_VERSION/crowdsec-firewall-bouncer-linux-$TARGETARCH.tgz 

ADD https://github.com/yfhme/y-cs-firewall-bouncer/releases/download/$FW_BOUNCER_VERSION/crowdsec-firewall-bouncer-linux-$TARGETARCH.tgz  /tmp/src/

WORKDIR /tmp/src

RUN rep_deps="ca-certificates gettext" && \
    set -x && \
    apt-get update && \
    apt-get purge -y --auto-remove nftables && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      #$rep_deps \
      gettext \
      ipset \
      iptables && \
    tar xzvf crowdsec-firewall-bouncer-linux-$TARGETARCH.tgz && \
    rm -f crowdsec-firewall-bouncer-linux-$TARGETARCH.tgz && \
    cd crowdsec-firewall-bouncer-$FW_BOUNCER_VERSION && \
    ./install.sh && \
    apt-get purge -y --auto-remove && \
      #$rep_deps && \
    rm -rf \
        /usr/local/go \
        /tmp/* \
        /var/tmp/* \
        /var/lib/apt/lists/*

ENTRYPOINT crowdsec-firewall-bouncer -c /crowdsec-firewall-bouncer.yaml