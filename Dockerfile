ARG VERSION=latest
FROM registry.access.redhat.com/ubi9/ubi-minimal:${VERSION}

RUN rpm -iv https://packages.distributed-ci.io/dci-release.el9.noarch.rpm
RUN microdnf install -y \
  python3 \
  jq \
  python3-dciclient && \
  dcictl --version

COPY add-component /

ENTRYPOINT [ "/add-component" ]
