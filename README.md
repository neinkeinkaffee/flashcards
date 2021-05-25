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
