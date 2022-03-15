#!/bin/sh
echo "app_server_ip -> ${app_server_ip}"
envsubst '${app_server_ip}' < /_src/nginx.conf > /etc/nginx/nginx.conf
cat /etc/nginx/nginx.conf
nginx -g "daemon off;"

