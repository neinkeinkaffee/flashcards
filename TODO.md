# Todos

### CI/CD
- Move building of e2e test container into seperate step
- Only build Docker containers if there were changes since the last build
- e2e test docker-compose: Check whether using `links` in docker-compose is deprecated
  
### DB
- Postgresql Docker entrypoint: Don't run create database if database exists
  
### Frontend
- Deck.js: Decouple model from CRUD backend calls
- Implement consistent way of syncing of state between frontend and DB
