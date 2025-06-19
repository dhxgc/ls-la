#!/bin/bash

FILENAME=$1
mkdir -p ./"$FILENAME"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./$FILENAME/$FILENAME.key -out ./$FILENAME/$FILENAME.crt
