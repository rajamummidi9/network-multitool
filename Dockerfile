FROM alpine:3.22

LABEL maintainer="rajamummidi9 <mummidiraja9@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/rajamummidi9/network-multitool"
LABEL org.opencontainers.image.description="Network troubleshooting multitool with nginx, curl, dig, tcpdump, and more"
LABEL org.opencontainers.image.licenses="MIT"

EXPOSE 80 443 1180 11443

# Networking and troubleshooting tools (alphabetical).
RUN apk update \
    && apk add --no-cache \
        bash bind-tools busybox-extras curl ethtool \
        iproute2 iputils iperf3 jq lsof mtr nmap-ncat \
        net-tools nginx openssh-client openssl \
        perl-net-telnet procps rsync socat tcpdump \
        tcptraceroute traceroute wget \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /certs /docker \
    && chmod 700 /certs \
    && openssl req \
        -x509 -newkey rsa:2048 -nodes -days 3650 \
        -keyout /certs/server.key -out /certs/server.crt -subj '/CN=localhost'

COPY index.html /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /docker/entrypoint.sh
COPY scripts/tools-check.sh /docker/tools-check.sh
RUN chmod +x /docker/entrypoint.sh /docker/tools-check.sh

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
    CMD curl -fsS "http://127.0.0.1:${HTTP_PORT:-80}/" >/dev/null || exit 1

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
ENTRYPOINT ["/bin/sh", "/docker/entrypoint.sh"]
