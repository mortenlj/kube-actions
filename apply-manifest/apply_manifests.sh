#!/usr/bin/bash

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # abort on pipe failures

if [[ -z "${KUBECONFIG}" ]]; then
  echo "::error::KUBECONFIG is not set. Ensure that a kubeconfig file is available, and that KUBECONFIG points to it."
  exit 1
fi

if [[ -z "${APPNAME}" ]]; then
  echo "APPNAME is not set. Looking up repository name from GitHub."
  APPNAME=${REPOSITORY##*/}
  echo "APPNAME=${APPNAME}"
fi

kubectl apply --namespace="${NAMESPACE}" "--filename=${FILENAME}" "--selector=app=${APPNAME}" --prune=true --wait=true "--timeout=${TIMEOUT}s"
