#!/usr/bin/env bash

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # abort on pipe failures

if [ -z "${ACTIONS_ID_TOKEN_REQUEST_TOKEN}" ] || [ -z "${ACTIONS_ID_TOKEN_REQUEST_URL}" ]; then
  echo "::error::Missing id-token permissions. This must be set either globally in the workflow, or for the specific job performing the deploy."

  exit 1
fi

pipx install httpie

mkdir -p /tmp/kubectl

echo "Requesting token from GitHub API"
jwt=$(http --ignore-stdin --json --auth-type bearer --auth "${ACTIONS_ID_TOKEN_REQUEST_TOKEN}" "${ACTIONS_ID_TOKEN_REQUEST_URL}" "audience==${AUDIENCE}" | jq -r '.value')

echo "Downloading kubeconfig from ${API_URL}"
http --download --output /tmp/kubectl/kubeconfig --ignore-stdin --json POST "${API_URL}/api/v1/token/kubeconfig" token="${jwt}"

echo "Kubeconfig downloaded to /tmp/kubectl/kubeconfig"
echo "KUBECONFIG=/tmp/kubectl/kubeconfig" >> "${GITHUB_ENV}"
