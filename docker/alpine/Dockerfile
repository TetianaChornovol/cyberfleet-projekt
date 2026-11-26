FROM alpine:3.22

RUN apk add --no-cache \
    openssh \
    python3 \
    sudo \
    curl \
    openssl \
    bash

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
