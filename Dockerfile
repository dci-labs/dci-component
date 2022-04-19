ARG VERSION=latest
FROM registry.access.redhat.com/ubi8/ubi:${VERSION}

RUN dnf install -y \
  python3 \
  jq && \
  pip3 install dciclient && \
  dcictl --version

COPY add-component .

ENTRYPOINT [ "./add-component" ]
