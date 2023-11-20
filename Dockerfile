FROM debian:stable-slim

ARG DEBIAN_FRONTEND=noninteractive

ENV FW_BOUNCER_VERSION=0.0.28

RUN rep_deps="curl ca-certificates" && \
    set -x && \
    apt-get update && \
    apt-get purge -y --auto-remove nftables && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      $rep_deps \
      ipset \
      iptables && \
    curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | bash && \
    apt-get update && \
    apt-get install -y crowdsec-firewall-bouncer-iptables=$FW_BOUNCER_VERSION && \
    apt-get purge -y --auto-remove \
      $rep_deps && \
    rm -rf \
        /usr/local/go \
        /tmp/* \
        /var/tmp/* \
        /var/lib/apt/lists/*

ENTRYPOINT crowdsec-firewall-bouncer -c /crowdsec-firewall-bouncer.yaml