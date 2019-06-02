# Flashcards

A minimalist flashcard app with a Vanilla JS frontend and a flask and postgres backend.

Many thanks to
https://github.com/testdrivenio/flask-vue-kubernetes
from where the backend with flask and postgres, the docker integration as well as the structure of this project have been adapted. 

Proper secret injection remains to be implemented.
For now, export the url of the flask backend into a bash variable and use sed to replace its occurrences before starting up the app.
```
sed -i "s#API_BASE_URL#'$API_BASE_URL'#g" services/client/src/Deck.js # Linux
sed -i "" s#API_BASE_URL#'$API_BASE_URL'#g" services/client/src/Deck.js # Mac OS
```

To run this application with docker-compose
```
docker-compose up -d --build
```
On a first time run, initialize the database with
``` 
docker-compose exec flask python manage.py recreate_db
docker-compose exec flask python manage.py seed_db 
``` 