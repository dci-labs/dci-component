FROM registry.access.redhat.com/ubi9/ubi-minimal@sha256:f26ef64172ea61f5ac5ba4be8c5c738bf8760b22b3e5148ce7b40f7308ab32db

RUN rpm --import https://dci-packages-prod.s3.amazonaws.com/RPM-GPG-KEY-distributedci-el9 && \
    rpm -iv https://packages.distributed-ci.io/dci-release.el9.noarch.rpm
RUN microdnf install -y \
  python3 \
  jq \
  python3-dciclient && \
  dcictl --version

COPY --chmod=0555 add-component /

ENTRYPOINT [ "/add-component" ]
