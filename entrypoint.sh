#!/bin/sh
set -e
set -o pipefail

if [[ -z "${AWS_ACCESS_KEY_ID}" ]]; then AWS_ACCESS_KEY_ID="${INPUT_AWSACCESSKEYID}"; fi
if [[ -z "${AWS_SECRET_ACCESS_KEY}" ]]; then AWS_SECRET_ACCESS_KEY="${INPUT_AWSSECRETACCESSKEY}"; fi
if [[ -z "${AWS_DEFAULT_REGION}" ]]; then AWS_DEFAULT_REGION="${INPUT_AWSDEFAULTREGION}"; fi
if [[ -z "${EKS_CLUSTER_NAME}" ]]; then EKS_CLUSTER_NAME="${INPUT_EKSCLUSTERNAME}"; fi

echo -e "\n\nhelm-action: setting up environment..."

aws configure set aws_access_key_id "${AWS_ACCESS_KEY_ID}"
aws configure set aws_secret_access_key "${AWS_SECRET_ACCESS_KEY}"
aws configure set default.region "${AWS_DEFAULT_REGION}"
aws eks update-kubeconfig --name "${EKS_CLUSTER_NAME}"

echo -e "\n\nhelm-action: executing command..."
sh -c "set -e; set -o pipefail; $1"