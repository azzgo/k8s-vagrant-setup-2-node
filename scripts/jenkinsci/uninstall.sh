#!/bin/sh

helm uninstall jenkins

helm uninstall docker-registry

helm uninstall nginx-ingress

echo "Deleted, run \"helm ls\" ing..."

helm ls
