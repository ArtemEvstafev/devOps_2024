#!/bin/bash

sudo docker run -d \
  --name db \
  -e POSTGRES_DB=mydatabase \
  -e POSTGRES_USER=myuser \
  -e POSTGRES_PASSWORD=mypassword \
  -p 5433:5432 \
  -v db_data:/var/lib/postgresql/data \
  -v $(pwd)/init.sql:/docker-entrypoint-initdb.d/init.sql \
  postgres:13

sudo docker run -d \
  --name web \
  --link db:db \
  -p 5000:5000 \
  amicus37/greeting:latest python3 app.py

sudo docker ps
