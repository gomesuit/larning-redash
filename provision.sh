#!/bin/bash
set -e


curl -fsSL https://get.docker.com/ | sh
systemctl enable docker
systemctl start docker

curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
export PATH=/usr/local/bin:$PATH

yum install -y git
git clone https://github.com/getredash/redash.git
cd redash/
cp docker-compose-example.yml docker-compose.yml

docker-compose up -d postgres

./setup/docker/create_database.sh

docker-compose up -d


