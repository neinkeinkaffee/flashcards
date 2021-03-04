#!/usr/bin/env bash
set -eo pipefail

function e2e_test() {
  pushd test
  docker-compose down
  docker-compose up -d --build
  docker-compose exec flask python manage.py recreate_db
  docker-compose exec flask python manage.py seed_db
  docker-compose run e2e py.test
  docker-compose down
  popd
}

function flask_test() {
  pushd services/backend
  docker-compose down
  docker-compose up -d
  docker-compose run test /bin/sh -c "pip install -r /data/requirements.txt && pytest /data/flashcards/tests"
  docker-compose down
  popd
}

CMD=${1:-}
shift || true
case ${CMD} in
e2e) e2e_test ;;
flask) flask_test ;;
esac
