# Flashcards

A minimalist flashcard app with a Vanilla JS frontend and a flask and postgres backend.

Many thanks to
https://github.com/testdrivenio/flask-vue-kubernetes
from where the backend with flask and postgres, the docker integration as well as the structure of this project have been adapted.

## Deploy with terraform

### Build the images

Build the flashcards-flask image and push it to Docker Hub:
```
docker build -t neinkeinkaffee/flashcards-flask ./services/backend
docker push neinkeinkaffee/flashcards-flask
```

Build the flashcards-nginx image and push it to Docker Hub:
```
docker build -t neinkeinkaffee/flashcards-nginx ./services/frontend
docker push neinkeinkaffee/flashcards-nginx
```

> Make sure to replace `neinkeinkaffee` with your Docker Hub namespace in the above commands as well as in *terraform/flask.tf* and *terraform/nginx.tf*.

### Fill in secrets
Copy `terraform/terraform.tfvars.template`, fill in the secret values and save it as `terraform/terraform.tfvars`.

### Apply terraform
```
./run terraform init
./run terraform apply -var-file=terraform.tfvars
```

### Initialize the database

Create the database:
```
./run kubectl exec $(./run kubectl get pods | grep -o "postgres-[-0-9a-z]*") -- createdb -U postgres flashcards
```

Apply the migrations and seed the database:
```
./run kubectl exec $(./run kubectl get pods | grep -o "flask-[-0-9a-z]*") -- python3 manage.py recreate_db
./run kubectl exec $(./run kubectl get pods | grep -o "flask-[-0-9a-z]*") -- python3 manage.py seed_db
```

## Run locally with docker-compose

To run this application with docker-compose
```
docker-compose up -d --build
```

On a first time run, initialize the database with
``` 
docker-compose exec postgres createdb -U postgres flashcards
docker-compose exec flask python manage.py recreate_db
docker-compose exec flask python manage.py seed_db 
``` 

Now you can visit `https://localhost` in your browser (you'll have to confirm that you want to proceed to a site with a self-signed certificate though). 
You can also query the flask backend API (and pipe through `jq` for prettier view).
```
curl localhost:5000/flashcards
{
  "container_id": "4f87b82a81f7",
  "flashcards": [
    {
      "chinese": "吃了嗎？",
      "english": "Have you eaten?",
      "id": 1
    },
    {
      "chinese": "去哪裡啊？",
      "english": "Where're ya headed?",
      "id": 2
    },
    {
      "chinese": "你來對了地方。",
      "english": "You've come to the right place.",
      "id": 3
    },
    {
      "chinese": "屁啦！",
      "english": "Nonsense!",
      "id": 4
    }
  ],
  "status": "success"
}
```

## Deploy with kubectl

(Adapted from https://github.com/testdrivenio/flask-vue-kubernetes.)

### Secrets

Create the secret object:
```
kubectl apply -f ./kubernetes/secret.yml
```

### Postgres

Create the persistent volume claim:
```
kubectl apply -f ./kubernetes/postgres-pvc.yml
```

Create deployment:
```
kubectl apply -f ./kubernetes/postgres-deployment.yml
```

Create the service:
```
kubectl apply -f ./kubernetes/postgres-service.yml
```

Create the database:
```
kubectl exec $(kubectl get pods | grep -o "postgres-[-0-9a-z]*") -- createdb -U postgres flashcards
```

### Flask

Build and push the image to Docker Hub:
```
docker build -t $SOME_DOCKER_HUB_NAMESPACE/flashcards-flask ./services/backend
docker push $SOME_DOCKER_HUB_NAMESPACE/flashcards-flask
```

> Make sure to replace `$SOME_DOCKER_HUB_NAMESPACE` with your Docker Hub namespace in the above commands as well as in *kubernetes/flask-deployment.yml*.

Create the deployment:
```
kubectl apply -f ./kubernetes/flask-deployment.yml
```

Create the service:
```
kubectl apply -f ./kubernetes/flask-service.yml
```

Apply the migrations and seed the database:
```
kubectl exec $(kubectl get pods | grep -o "flask-[-0-9a-z]*") -- python3 manage.py recreate_db
kubectl exec $(kubectl get pods | grep -o "flask-[-0-9a-z]*") -- python3 manage.py seed_db
```

### Nginx

Build and push the image to Docker Hub:
```
docker build -t $SOME_DOCKER_HUB_NAMESPACE/flashcards-nginx ./services/frontend
docker push $SOME_DOCKER_HUB_NAMESPACE/flashcards-nginx
```

> Make sure to replace `$SOME_DOCKER_HUB_NAMESPACE` with your Docker Hub namespace in the above commands as well as in *kubernetes/flask-deployment.yml*.

Create the deployment:
```
kubectl apply -f ./kubernetes/nginx-deployment.yml
```

Create the service:
```
kubectl apply -f ./kubernetes/nginx-service.yml
```