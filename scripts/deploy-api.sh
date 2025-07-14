#!/bin/bash

set -e

# Build for dev - lambda entrypoint
NX_TUI=false nx run mwd-skeleton:build:development --skip-nx-cache
NX_TUI=false nx run mwd-skeleton:postbuild:development --skip-nx-cache
cd apps/mwd-skeleton/dist
yarn install

# Zip dist for deployment
zip -r ../../../infra/tmp/mwd-skeleton.zip . > /dev/null
cd -

# Deploy the lambda function code
aws lambda update-function-code --function-name ApiLambda \
--zip-file fileb://infra/tmp/mwd-skeleton.zip

# Clean up
rm infra/tmp/mwd-skeleton.zip

echo "Deployed API"
