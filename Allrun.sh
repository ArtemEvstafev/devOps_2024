#!/bin/bash

sudo docker-compose up -d

URL="http://localhost:5000"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open "$URL"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    open "$URL"
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    start "$URL"
else
    echo "Операционная система не поддерживается для автоматического открытия URL."
fi
