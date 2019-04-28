FROM nginx:alpine
COPY src /usr/share/nginx/html
COPY entrypoint.sh /entrypoint.sh
RUN apk --no-cache add openssl && \
    openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/private/snakeoil-key.pem -out /etc/ssl/snakeoil-cert.pem -days 365 -nodes -subj '/CN=localhost' && \
    apk del --purge openssl
CMD ["/entrypoint.sh"]