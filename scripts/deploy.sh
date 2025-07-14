#!/bin/bash

set -e

# Create the necessary buckets and deploy the CloudFormation stack
if ! aws s3api head-bucket --bucket "mwd-skeleton-dev-cfn" 2>/dev/null; then
  echo "Creating CloudFormation bucket"
  aws s3 mb "s3://mwd-skeleton-dev-cfn"
fi

if ! aws s3api head-bucket --bucket "mwd-skeleton-dev-functions" 2>/dev/null; then
  echo "Creating lambda functions bucket"
  aws s3 mb "s3://mwd-skeleton-dev-functions"
fi

echo "Cleaning bucket"
aws s3 rm "s3://mwd-skeleton-dev-cfn" --recursive

echo "Packaging"
aws cloudformation package --template-file "infra/src/stack.yml" \
  --s3-bucket "mwd-skeleton-dev-cfn" \
  --output-template-file "infra/dist/dev-eu-west-2-output.yml"

echo "Deploying"
aws cloudformation deploy --stack-name "mwd-skeleton-dev" \
  --template-file "infra/dist/dev-eu-west-2-output.yml" \
  --region "eu-west-2" \
  --capabilities CAPABILITY_NAMED_IAM

echo "Deploying API"
sh scripts/deploy-api.sh
