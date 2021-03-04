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

CMD=${1:-}
shift || true
case ${CMD} in
e2e) e2e_test ;;
esac
