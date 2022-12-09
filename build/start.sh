#!/bin/bash
chown postgres /var/lib/postgresql/data
lighttpd -D -f /etc/lighttpd/lighttpd.conf &
sleep 2
su postgres -c initdb
su postgres -c "pg_ctl start | rotatelogs /var/log/pgsql_log 86400"
