#!/bin/sh

NAME=biodranik/nginx-letsencrypt
DATE=$(date -u +%y%m%d)
docker build --squash -t "$NAME:latest" -t "$NAME:$DATE" .
