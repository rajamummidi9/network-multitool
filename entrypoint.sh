#!/bin/sh

WEB_ROOT=/usr/share/nginx/html
MOUNT_CHECK=$(mount | grep ${WEB_ROOT})
HOSTNAME=$(hostname)
CONTAINER_IP=$(ip -j route get 1 2>/dev/null | jq -r '.[0] .prefsrc // empty')

if [ -z "${MOUNT_CHECK}" ] ; then
 CONTAINER_IP=${CONTAINER_IP:-unknown}
 echo -e "Network MultiTool - rajamummidi9 - ${HOSTNAME} - ${CONTAINER_IP} - HTTP: ${HTTP_PORT:-80} , HTTPS: ${HTTPS_PORT:-443}" > ${WEB_ROOT}/index.html
fi

if [ -n "${HTTP_PORT}" ]; then
 sed -i "s/80/${HTTP_PORT}/g" /etc/nginx/nginx.conf
fi

if [ -n "${HTTPS_PORT}" ]; then
 sed -i "s/443/${HTTPS_PORT}/g" /etc/nginx/nginx.conf
fi

exec "$@"
