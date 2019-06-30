FROM nginx:alpine
COPY src /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
RUN apk --no-cache add openssl && \
    openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/private/snakeoil-key.pem -out /etc/ssl/snakeoil-cert.pem -days 365 -nodes -subj '/CN=localhost' && \
    apk del --purge openssl
CMD envsubst < /usr/share/nginx/html/src/services/client/src/Deck.js > /usr/share/nginx/html/src/services/client/src/Deck.js.tmp \
 && mv /usr/share/nginx/html/src/services/client/src/Deck.js.tmp /usr/share/nginx/html/src/services/client/src/Deck.js \
 && nginx -g 'daemon off;'
