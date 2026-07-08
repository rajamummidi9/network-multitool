#!/bin/sh

# OpenShift runs containers with a random UID. Ensure passwd entry exists.
if [ -n "${RUNTIME_USER_NAME:-}" ]; then
  if ! id -u "${RUNTIME_USER_NAME}" >/dev/null 2>&1; then
    echo "${RUNTIME_USER_NAME}:x:$(id -u):0:${RUNTIME_USER_NAME}:/:/sbin/nologin" >> /etc/passwd
  fi
fi

WEB_ROOT=/usr/share/nginx/html
MOUNT_CHECK=$(mount | grep ${WEB_ROOT})
HOSTNAME=$(hostname)
CONTAINER_IP=$(ip -j route get 1 2>/dev/null | jq -r '.[0] .prefsrc // empty')
HTTP_PORT=${HTTP_PORT:-1180}
HTTPS_PORT=${HTTPS_PORT:-11443}

if [ -z "${MOUNT_CHECK}" ] ; then
  CONTAINER_IP=${CONTAINER_IP:-unknown}
  echo -e "Network MultiTool - rajamummidi9 - ${HOSTNAME} - ${CONTAINER_IP} - HTTP: ${HTTP_PORT} , HTTPS: ${HTTPS_PORT}" > ${WEB_ROOT}/index.html
fi

sed -i "s/1180/${HTTP_PORT}/g" /etc/nginx/nginx.conf
sed -i "s/11443/${HTTPS_PORT}/g" /etc/nginx/nginx.conf

exec "$@"
