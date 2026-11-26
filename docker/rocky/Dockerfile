FROM rockylinux:9

RUN dnf install -y \
    openssh-server \
    openssh-clients \
    python3 \
    sudo \
    openssl \
    && dnf clean all

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]

