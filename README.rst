kube-actions
============

Github actions for Kubernetes on Ibidem

This repository contains two actions:

1. Get Kubeconfig
   Use OIDC to request a kubeconfig from Ibidem API.
2. Kubectl Apply
   Applies kubernetes manifests using kubectl, pruning outdated resources based on a label.

Usage
-----

Requires a linux runner with bash and kubectl available.
The standard GitHub runners provides this.
