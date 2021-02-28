#!/usr/bin/env bash
set -eo pipefail

pushd test

docker-compose down
docker-compose up -d --build
docker-compose exec flask python manage.py recreate_db
docker-compose exec flask python manage.py seed_db
docker-compose run e2e py.test
docker-compose down

popd
