# Flashcards

A minimalist flashcard app with a Vanilla JS frontend and a flask and postgres backend.

Many thanks to
https://github.com/testdrivenio/flask-vue-kubernetes
from where the backend with flask and postgres, the docker integration as well as the structure of this project have been adapted. 

### Run with docker-compose

To run this application with docker-compose
```
docker-compose up -d --build
```

On a first time run, initialize the database with
``` 
docker-compose exec flask python manage.py recreate_db
docker-compose exec flask python manage.py seed_db 
``` 

### Run with kubernetes

(Adapted from https://github.com/testdrivenio/flask-vue-kubernetes.)

#### Volume

Create the volume:
```
kubectl apply -f ./kubernetes/persistent-volume.yml
```

Create the volume claim:
```
kubectl apply -f ./kubernetes/persistent-volume-claim.yml
```

#### Secrets

Create the secret object:
```
kubectl apply -f ./kubernetes/secret.yml
```

#### Postgres

Create deployment:
```
kubectl create -f ./kubernetes/postgres-deployment.yml
```

Create the service:
```
kubectl create -f ./kubernetes/postgres-service.yml
```

Create the database:
```
kubectl get pods
kubectl exec postgres-<POD_IDENTIFIER> --stdin --tty -- createdb -U postgres flashcards
```

#### Flask

Build and push the image to Docker Hub:
```
docker build -t $SOME_DOCKER_HUB_NAMESPACE/flashcards-flask ./services/server
docker push $SOME_DOCKER_HUB_NAMESPACE/flashcards-flask
```

> Make sure to replace `$SOME_DOCKER_HUB_NAMESPACE` with your Docker Hub namespace in the above commands as well as in *kubernetes/flask-deployment.yml*.

Create the deployment:
```
kubectl create -f ./kubernetes/flask-deployment.yml
```

Create the service:
```
kubectl create -f ./kubernetes/flask-service.yml
```

Apply the migrations and seed the database:
```
kubectl get pods
kubectl exec flask-<POD_IDENTIFIER> --stdin --tty -- python manage.py recreate_db
kubectl exec flask-<POD_IDENTIFIER> --stdin --tty -- python manage.py seed_db
```

#### Nginx

Build and push the image to Docker Hub:
```
docker build -t $SOME_DOCKER_HUB_NAMESPACE/flashcards-nginx ./services/server
docker push $SOME_DOCKER_HUB_NAMESPACE/flashcards-nginx
```

> Make sure to replace `$SOME_DOCKER_HUB_NAMESPACE` with your Docker Hub namespace in the above commands as well as in *kubernetes/flask-deployment.yml*.

Create the deployment:
```
kubectl create -f ./kubernetes/nginx-deployment.yml
```

Create the service:
```
kubectl create -f ./kubernetes/nginx-service.yml
```
