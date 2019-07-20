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

cd ks_app

ks param set tf-job-operator tfJobImage gcr.io/kubeflow-images-public/tf_operator:latest

cd -

../scripts/kfctl.sh apply k8s

oc expose svc ambassador
oc expose svc argo-ui