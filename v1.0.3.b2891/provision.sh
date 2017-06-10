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

docker-compose run --rm server create_db
docker-compose up -d

## create database
#cd /vagrant
#
#run_redash="docker-compose run --rm redash"
#
#$run_redash /opt/redash/current/manage.py database create_tables
#
## Create default admin user
#$run_redash /opt/redash/current/manage.py users create --admin --password admin "Admin" "admin"
#
#run_psql="sudo -u postgres psql -h 192.168.33.60"
#
## Create redash_reader user. We don't use a strong password, as the instance supposed to be accesible only from the redash host.
#$run_psql -c "CREATE ROLE redash_reader WITH PASSWORD 'redash_reader' NOCREATEROLE NOCREATEDB NOSUPERUSER LOGIN"
#$run_psql -c "grant select(id,name,type) ON data_sources to redash_reader;"
#$run_psql -c "grant select(id,name) ON users to redash_reader;"
#$run_psql -c "grant select on events, queries, dashboards, widgets, visualizations, query_results to redash_reader;"
#
#$run_redash /opt/redash/current/manage.py ds new "Redash Metadata" --type "pg" --options "{\"user\": \"redash_reader\", \"password\": \"redash_reader\", \"host\": \"postgres\", \"dbname\": \"postgres\"}"
#
#docker-compose up -d



