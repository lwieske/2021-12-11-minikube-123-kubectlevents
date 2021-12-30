#!/usr/bin/env bash

minikube start \
    --kubernetes-version=v1.23.0 \
    --container-runtime=containerd \
    --driver=hyperkit

sleep 60

set +x
echo "################################################################################"
echo "### kubectl alpha events"
echo "################################################################################"
set -x

curl --location --silent https://k8s.io/examples/application/nginx-with-request.yaml

kubectl apply -f https://k8s.io/examples/application/nginx-with-request.yaml

sleep 20

set +x
echo "################################################################################"
echo "### lookup deployment nginx-deployment"
echo "################################################################################"
set -x

kubectl describe deployment nginx-deployment

sleep 20

kubectl get events

kubectl scale deployment nginx-deployment --replicas=5

sleep 60

kubectl get pods

sleep 20

set +x
echo "################################################################################"
echo "### these are not sorted"
echo "################################################################################"
set -x

kubectl get events | \
  tail -20 | \
  cut -c -150

sleep 20

set +x
echo "################################################################################"
echo "### these are sorted"
echo "################################################################################"
set -x

kubectl alpha events --all-namespaces | \
  tail -20 | \
  cut -c -150

sleep 20