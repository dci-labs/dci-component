FROM registry.access.redhat.com/ubi9/ubi-minimal@sha256:2e8edce823a48e51858f1fad3ff4cbf6875ce8a3f86b9eecf298bc2050c8652a

RUN rpm --import https://dci-packages-prod.s3.amazonaws.com/RPM-GPG-KEY-distributedci-el9 && \
    rpm -iv https://packages.distributed-ci.io/dci-release.el9.noarch.rpm
RUN microdnf install -y \
  python3 \
  jq \
  python3-dciclient && \
  dcictl --version

COPY --chmod=0555 add-component /

ENTRYPOINT [ "/add-component" ]
