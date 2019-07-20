#!/usr/bin/env bash

export KUBEFLOW_TAG=v0.4.1
export KUBEFLOW_SRC=install

cd ${KUBEFLOW_SRC}/openshift

../scripts/kfctl.sh delete k8s

oc delete CustomResourceDefinition applications.app.k8s.io
oc delete CustomResourceDefinition compositecontrollers.metacontroller.k8s.io
oc delete CustomResourceDefinition controllerrevisions.metacontroller.k8s.io
oc delete CustomResourceDefinition decoratorcontrollers.metacontroller.k8s.io
oc delete CustomResourceDefinition notebooks.kubeflow.org
oc delete CustomResourceDefinition profiles.kubeflow.org
oc delete CustomResourceDefinition pytorchjobs.kubeflow.org
oc delete CustomResourceDefinition scheduledworkflows.kubeflow.org
oc delete CustomResourceDefinition studyjobs.kubeflow.org
oc delete CustomResourceDefinition tfjobs.kubeflow.org
oc delete CustomResourceDefinition viewers.kubeflow.org
oc delete CustomResourceDefinition workflows.argoproj.io

cd -

rm -rf ${KUBEFLOW_SRC}