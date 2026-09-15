FROM registry.access.redhat.com/ubi9/ubi-minimal@sha256:186a94b76e386782f576c9c49813b16dceb2ba63102af5a28405dcefec2806d0

RUN rpm --import https://dci-packages-prod.s3.amazonaws.com/RPM-GPG-KEY-distributedci-el9 && \
    rpm -iv https://packages.distributed-ci.io/dci-release.el9.noarch.rpm
RUN microdnf install -y \
  python3 \
  jq \
  python3-dciclient && \
  dcictl --version

COPY --chmod=0555 add-component /

ENTRYPOINT [ "/add-component" ]
