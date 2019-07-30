#!/bin/bash
set -e
set -u


# cdata_admin
cdata_admin_id="{$CDATA_ADMIN_ID:-admin}"
cdata_admin_pw="{$CDATA_ADMIN_PW:-cdatapasswd}"

echo "<?xml version='1.0' ?><tomcat-users><user name='$cdata_admin' password='$cdata_pw' roles='cdata_admin' /></tomcat-users>" > /app/tomcat-users.xml


# db connection
db_url="${DATABASE_URL}"
regex="postgres://([a-z]+):([a-z0-9]+)@(.+):([0-9]+)/([a-z0-9]+)"
if [[ $db_url =~ $regex ]]; then
  echo "ok"
  echo "-----"
  user=${BASH_REMATCH[1]}
  pw=${BASH_REMATCH[2]}
  host=${BASH_REMATCH[3]}
  port=${BASH_REMATCH[4]}
  db=${BASH_REMATCH[5]}

  jdbc="jdbc:postgresql://$host:$port/$db?user=$user&password=$pw"
  echo ${jdbc}
  export APP_DB="${jdbc}"
  export APP_USERS="${jdbc}"
else
  exit 1
fi

