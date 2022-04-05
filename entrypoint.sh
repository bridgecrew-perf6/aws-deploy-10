#!/bin/sh -l

aws --version 

BUCKET_NAME=$1
HELM_NAME=$2
HELM_APP=$3
VERSION_APP=$4
AWS_ACCOUNT_ID=$5
AWS_ACCESS_KEY=$6
AWS_ACCESS_SECRET=$7
AWS_REGION=$8
CLUSTER_ID=$9

AWS_CONTAINER_REGISTRY_URL=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
echo " ============================================ "
echo " BUCKET_NAME: ${BUCKET_NAME}"
echo " HELM_NAME: ${HELM_NAME}"
echo " HELM_APP: ${HELM_APP}"
echo " VERSION_APP: ${VERSION_APP}"
echo " AWS_ACCOUNT_ID: ${AWS_ACCOUNT_ID}"
echo " AWS_ACCESS_KEY: ********"
echo " AWS_ACCESS_SECRET: *******"
echo " AWS_REGION: ${AWS_REGION}"
echo " CLUSTER_ID: ${CLUSTER_ID}"
echo " AWS_CONTAINER_REGISTRY_URL: ${AWS_CONTAINER_REGISTRY_URL}"
echo " ============================================ "


aws configure set aws_access_key_id "${AWS_ACCESS_KEY}"
aws configure set aws_secret_access_key "${AWS_ACCESS_SECRET}"
aws configure set default.region "${AWS_REGION}"

aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_CONTAINER_REGISTRY_URL}

aws s3api get-object --bucket ${BUCKET_NAME} --key ${HELM_NAME} ${HELM_NAME}

aws eks update-kubeconfig --name ${CLUSTER_ID} --region ${AWS_REGION}

helm upgrade ${HELM_APP} ${HELM_NAME} --set=image.tag=${VERSION_APP}
