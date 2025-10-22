#!/usr/bin/env bash

db=$(openssl rand -base64 32 | cut -b -32 | tr -dc a-zA-Z0-9!@#%_-)
adm=$(openssl rand -base64 32 | cut -b -32 | tr -dc a-zA-Z0-9!@#%_-)
usr=$(openssl rand -base64 32 | cut -b -32 | tr -dc a-zA-Z0-9!@#%_-)

sed -i s/^DATABASE_PASSWORD=$/DATABASE_PASSWORD="\"$db\""/ "$1"

sed -i s/^WORDPRESS_ADMIN_PASSWORD=$/WORDPRESS_ADMIN_PASSWORD="\"$adm\""/ "$1"

sed -i s/^WORDPRESS_PASSWORD=$/WORDPRESS_PASSWORD="\"$usr\""/ "$1"
