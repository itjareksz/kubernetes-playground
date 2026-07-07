#!/bin/bash

kubectl apply -f ./05_pod_inspect_network.yaml
echo "Starting Pod with Ubuntu container..."
echo "Use commands such as ping, curl, and try to connect to different Pods."
echo "This will allow checking if Kubernetes NetworkPolicy is applied."
sleep 10
kubectl exec -it ubuntu -- bash
