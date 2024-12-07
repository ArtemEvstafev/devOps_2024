#!/bin/bash

kubectl delete all --all -n greeting-app
kubectl delete namespace greeting-app
minikube stop
minikube delete
minikube cache delete

