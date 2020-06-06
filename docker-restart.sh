#!/bin/sh
set -x

if [ $1 = 'mac' ]; then
    sed -i "" "s@API_BASE_URL@'$API_BASE_URL'@g" services/client/src/Deck.js
else
    sed -i "s@API_BASE_URL@'$API_BASE_URL'@g" services/client/src/Deck.js
fi

docker-compose down
docker-compose up -d --build
docker-compose exec flask python manage.py recreate_db
docker-compose exec flask python manage.py seed_db

if [ $1 = 'mac' ]; then
    sed -i "" "s@'$API_BASE_URL'@API_BASE_URL@g" services/client/src/Deck.js
else
    sed -i "s@'$API_BASE_URL'@API_BASE_URL@g" services/client/src/Deck.js
fi