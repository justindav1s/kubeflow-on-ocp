#Minio Client

brew install minio/stable/mc

https://docs.min.io/docs/minio-client-complete-guide.html

mc config host add minio https://minio-service-kubeflow.apps.ocp.datr.eu minio <secret> --api S3v4

get the secret from the deployment environment (defaults to minio123)

mb minio/bucket1

Make puclic bucket

mc mb minio/public

echo "the quick brown fox" > test.txt

mc cp test.txt minio/public

mc policy public minio/public

➜  ~ curl https://minio-service-kubeflow.apps.ocp.datr.eu/public/test.txt
the quick brown fox









