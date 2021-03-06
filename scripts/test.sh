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
  docker-compose run test /bin/sh -c "pip install -r /data/requirements.txt && pytest /data/flashcards/tests"
  popd
}

function js_test () {
  pushd services/frontend
  docker-compose run test /bin/sh run_jasmine.sh
  popd
}

function run_locally_start() {
  pushd test
  docker-compose down
  docker-compose up -d --build
  docker-compose exec flask python manage.py recreate_db
  docker-compose exec flask python manage.py seed_db
  popd
}

function run_locally_stop() {
  pushd test
  docker-compose down
  popd
}

CMD=${1:-}
shift || true
case ${CMD} in
e2e) e2e_test ;;
flask) flask_test ;;
js) js_test ;;
start) run_locally_start ;;
stop) run_locally_stop ;;
esac
