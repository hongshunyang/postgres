#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

POSTGRES_MINOR_VER=$(echo "${POSTGRES_VER}" | grep -oE '^[0-9]+\.[0-9]+?')

if [[ -z "${POSTGRES_PASSWORD}" ]]; then
    echo "Environment variable POSTGRES_PASSWORD is required. Exiting."
    exit 1
fi

if [[ -z "${POSTGRES_DB}" ]]; then
    export POSTGRES_DB="${POSTGRES_USER}"
fi

mkdir -p /etc/postgresql/
gotpl "/etc/gotpl/postgresql-${POSTGRES_MINOR_VER}.conf.tpl" > "/etc/postgresql/postgresql.conf"

if [[ $1 == 'make' ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    exec /usr/local/bin/docker-entrypoint.sh "${@}"
fi
