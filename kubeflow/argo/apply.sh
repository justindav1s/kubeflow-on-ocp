#!/usr/bin/env bash

oc apply -f argo-role.yml -n kubeflow

oc adm policy add-scc-to-user privileged -z argo -n kubeflow