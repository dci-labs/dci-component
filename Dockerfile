ARG VERSION=latest
FROM registry.access.redhat.com/ubi8/ubi:${VERSION}

RUN dnf -y install https://packages.distributed-ci.io/dci-release.el8.noarch.rpm && \
  dnf install -y \
  python3 \
  jq \
  python3-dciclient && \
  dcictl --version

COPY add-component /

ENTRYPOINT [ "/add-component" ]
