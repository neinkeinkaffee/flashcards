#!/usr/bin/env bash
set -eo pipefail

function e2e_test() {
  pushd e2e-test
  docker-compose down
  BASE_URL=http://flashcards docker-compose up -d --build
  docker-compose exec flask python manage.py recreate_db
  docker-compose exec flask python manage.py seed_db
  docker-compose run e2e py.test
  docker-compose down
  popd
}

function flask_test() {
  pushd services/backend
  docker-compose run test /bin/sh -c "pip install -r /data/requirements.txt && pytest /data/flashcards/e2e-test"
  popd
}

function js_test () {
  pushd services/frontend
  docker-compose run test /bin/sh run_jasmine.sh
  popd
}

function run_locally_start() {
  pushd e2e-test
  docker-compose down
  BASE_URL=http://localhost docker-compose up -d --build
  docker-compose exec flask python manage.py recreate_db
  docker-compose exec flask python manage.py seed_db
  popd
}

function run_locally_stop() {
  pushd e2e-test
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
