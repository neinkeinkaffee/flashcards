# Flashcards

Many thanks to
https://github.com/testdrivenio/flask-vue-kubernetes
from where the backend with flask and postgres, the docker integration as well as the project structure have been adapted. 

To run this application with docker-compose
```
docker-compose up -d --build
```
On a first time run, initialize the database with
``` 
docker-compose exec server python manage.py recreate_db
docker-compose exec server python manage.py seed_db 
``` 