#!/usr/bin/env bash
set -eo pipefail

docker-compose down
docker-compose up -d --build
docker-compose exec flask python manage.py recreate_db
docker-compose exec flask python manage.py seed_db
pytest test_e2e.py
