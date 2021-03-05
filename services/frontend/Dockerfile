FROM arm32v6/alpine:3.7
COPY qemu-arm-static /usr/bin/

# Install dependencies
RUN apk --no-cache --update add nginx &&\
    mkdir -p /run/nginx && \
    apk add gettext libintl

# Configure nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Add app
COPY src /usr/share/nginx/html

# Run server
CMD  envsubst < /usr/share/nginx/html/Deck.js > /usr/share/nginx/html/Deck.js.tmp && \
     mv /usr/share/nginx/html/Deck.js.tmp /usr/share/nginx/html/Deck.js && \
     envsubst < /usr/share/nginx/html/index.html > /usr/share/nginx/html/index.html.tmp && \
     mv /usr/share/nginx/html/index.html.tmp /usr/share/nginx/html/index.html && \
     nginx -g 'daemon off;'
