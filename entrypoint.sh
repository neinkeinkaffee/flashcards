#!/bin/sh

set -eu -o pipefail

echo "hello world"

KEY_FILE=${KEY_FILE:-/etc/ssl/private/snakeoil-key.pem}
CERT_FILE=${CERT_FILE:-/etc/ssl/snakeoil-cert.pem}

cat > /etc/nginx/nginx.conf <<EOF
worker_processes 1;

events { worker_connections 1024; }

http {

    server {
        listen 443 ssl;

        ssl_certificate     "$CERT_FILE";
        ssl_certificate_key "$KEY_FILE";
        ssl_protocols       TLSv1.2;
        ssl_ciphers         HIGH:!aNULL:!MD5;

        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }
    }
}
EOF

nginx -g "daemon off;"