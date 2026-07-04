#!/bin/bash

set -eu -o pipefail
# Uncomment for debug
# set -x

# Kind install instruction from: https://kind.sigs.k8s.io/docs/user/quick-start

# For AMD64 / x86_64
[ "$(uname -m)" = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.32.0/kind-linux-amd64

chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
