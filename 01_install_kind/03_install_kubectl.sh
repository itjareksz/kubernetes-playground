#!/bin/bash

set -eu -o pipefail
# Uncomment for debug
# set -x

# kubectl install instruction from: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

echo
echo "Adding kubectl autocompletion for Bash for current user..."
echo -e '\n# kubectl autocompletion\nsource <(kubectl completion bash)' >>~/.bashrc
echo "Completed."
echo "Open new terminal and kubectl should suggest command completion when using Tab key."
