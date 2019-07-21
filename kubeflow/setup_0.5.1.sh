#!/usr/bin/env bash

export KUBEFLOW_TAG=v0.5.1
export KUBEFLOW_SRC=install

rm -rf ${KUBEFLOW_SRC} && mkdir ${KUBEFLOW_SRC} && cd ${KUBEFLOW_SRC}

curl https://raw.githubusercontent.com/kubeflow/kubeflow/${KUBEFLOW_TAG}/scripts/download.sh | bash

export KFAPP=openshift
scripts/kfctl.sh init ${KFAPP} --platform none
cd ${KFAPP}
../scripts/kfctl.sh generate k8s

oc adm policy add-scc-to-user anyuid -z ambassador -n kubeflow
oc adm policy add-scc-to-user anyuid -z jupyter -n kubeflow
oc adm policy add-scc-to-user anyuid -z katib-ui -n kubeflow
oc adm policy add-scc-to-user anyuid -z default -n kubeflow
oc adm policy add-scc-to-user anyuid -z studyjob-controller -n kubeflow
oc adm policy add-scc-to-user anyuid -z jupyter-notebook -n kubeflow

../scripts/kfctl.sh apply k8s

# https://github.com/kubeflow/kubeflow/issues/3086
oc patch --type=json clusterrole notebooks-controller -p '[{"op":"add", "path":"/rules/-", "value":{"apiGroups":["kubeflow.org"],"resources":["notebooks/finalizers"],"verbs":["*"]}}]'
# Some informations about oc patch
#   https://access.redhat.com/articles/3319751
#   https://kubernetes.io/docs/tasks/run-application/update-api-object-kubectl-patch/
#   JavaScript Object Notation (JSON) Patch: https://tools.ietf.org/html/rfc6902

oc project kubeflow

oc expose svc argo-ui
oc expose svc ambassador
oc expose svc minio-service