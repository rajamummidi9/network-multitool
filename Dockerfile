FROM alpine:3.19

LABEL maintainer="Raja Mummidi <rajamummidi9@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/rajamummidi9/network-multitool"
LABEL org.opencontainers.image.description="Network troubleshooting multitool with nginx, curl, dig, tcpdump, and more"
LABEL org.opencontainers.image.licenses="MIT"

EXPOSE 80 443 1180 11443

# Install networking tools and generate self-signed SSL certificates.
# Packages listed alphabetically for readability and maintenance.
RUN apk update \
    && apk add --no-cache bash bind-tools busybox-extras curl \
                iproute2 iputils jq mtr \
                net-tools nginx openssl \
                perl-net-telnet procps tcpdump tcptraceroute wget \
    && mkdir -p /certs /docker \
    && chmod 700 /certs \
    && openssl req \
        -x509 -newkey rsa:2048 -nodes -days 3650 \
        -keyout /certs/server.key -out /certs/server.crt -subj '/CN=localhost'

COPY index.html /usr/share/nginx/html/
COPY press-release.md /root/
COPY press-release.html /root/
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /docker/entrypoint.sh
RUN chmod +x /docker/entrypoint.sh

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
ENTRYPOINT ["/bin/sh", "/docker/entrypoint.sh"]
