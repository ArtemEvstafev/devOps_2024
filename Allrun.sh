#!/bin/bash

# minikube should be installed
minikube start --driver=docker
cd k8s
kubectl apply -f namespace.yml && kubectl apply -f postgres-pvc.yml && kubectl apply -f init-sql-configmap.yml && kubectl apply -f postgres-deployment.yml && kubectl apply -f web-deployment.yml
kubectl get svc -n greeting-app -o wide
WEB_PORT=$(kubectl get svc -n greeting-app -o wide | awk '/web/ {print $5}' | cut -d ':' -f 2 | cut -d '/' -f 1)
sleep 120
kubectl get pods -n greeting-app -o wide
kubectl get nodes -o wide
INTERNAL_IP=$(kubectl get nodes -o wide | awk '/minikube/ {print $6}')
curl http://$INTERNAL_IP:$WEB_PORT





