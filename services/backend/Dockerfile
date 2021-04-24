FROM arm32v6/python:3.7-alpine3.13
COPY qemu-arm-static /usr/bin/

# Set working directory
WORKDIR /usr/src/app

# Install dependencies
COPY ./requirements.txt /usr/src/app/requirements.txt
RUN apk update && apk add libpq && \
    apk add --virtual .build-deps gcc g++ python3-dev py3-pip musl-dev postgresql-dev && \
    pip3 install -r requirements.txt && \
    apk del .build-deps

# Add entrypoint.sh
COPY ./entrypoint.sh /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh

# Add app
COPY . /usr/src/app

# Run server
CMD ["/usr/src/app/entrypoint.sh"]
