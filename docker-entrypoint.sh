#!/bin/sh
set -e

# mysqld
if [ ! -d "/var/lib/mysql/" ] || [ ! -d "/var/lib/mysql/mysql" ]; then
    mysqld --initialize --user=mysql --datadir=/var/lib/mysql
else
    echo "/var/lib/mysql exists."
fi

/usr/sbin/mysqld --user=mysql &

(
    sleep 3
    cat /var/log/mysqld.log
) &

# exec commands
if [ -n "$*" ]; then
    sh -c "$*"
fi

# keep the docker container running
# https://github.com/docker/compose/issues/1926#issuecomment-422351028
if [ "${KEEPALIVE}" -eq 1 ]; then
    trap : TERM INT
    tail -f /dev/null &
    wait
    # sleep infinity & wait
fi
