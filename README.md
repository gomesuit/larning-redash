# larning-redash


```
git clone https://github.com/getredash/redash
cd redash

docker-machine create redash -d virtualbox
eval $(docker-machine env redash)

docker-compose up -d postgres

./setup/docker/create_database.sh

docker-compose up -d


# http://$(docker-machine ip redash)

```


