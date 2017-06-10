#!/bin/bash
set -e

# install docker
curl -fsSL https://get.docker.com/ | sh
systemctl enable docker
systemctl start docker

# install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
export PATH=/usr/local/bin:$PATH

# install postgres
yum install -y 'https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm'
yum install -y postgresql96-server
/usr/pgsql-9.6/bin/postgresql96-setup initdb
cp -f /vagrant/postgresql.conf /var/lib/pgsql/9.6/data/postgresql.conf
cp -f /vagrant/pg_hba.conf /var/lib/pgsql/9.6/data/pg_hba.conf
systemctl start postgresql-9.6

cd /vagrant
docker-compose run --rm server create_db
docker-compose up -d
