# Flashcards

A minimalist flashcard app with a Vanilla JS frontend and a flask and postgres backend.

Many thanks to
https://github.com/testdrivenio/flask-vue-kubernetes
from where the backend with flask and postgres, the docker integration as well as the structure of this project have been adapted. 

Proper secret injection remains to be implemented.
For now, replace the placeholder for the URL of the flask backend with sed before starting up the app.
```
sed -i "s#API_BASE_URL#$API_URL#g" services/client/src/Deck.js # Linux
sed -i "" s#API_BASE_URL#$API_URL#g" services/client/src/Deck.js # Mac OS
```

To run this application with docker-compose
```
docker-compose up -d --build
```
On a first time run, initialize the database with
``` 
docker-compose exec server python manage.py recreate_db
docker-compose exec server python manage.py seed_db 
``` 