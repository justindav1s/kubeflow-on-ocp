#!/usr/bin/env bash


cd ../install/openshift/ks_app


CNN_JOB_NAME=testcnnjob
VERSION=master
ks registry add kubeflow-git github.com/kubeflow/kubeflow/tree/${VERSION}/kubeflow
ks pkg install kubeflow-git/examples
ks generate tf-job-simple ${CNN_JOB_NAME} --name=${CNN_JOB_NAME}