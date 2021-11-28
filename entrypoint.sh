#!/bin/sh

set -x
# aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID; 
# aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY; 
# aws configure set default.region $AWS_DEFAULT_REGION

cd $FUNCTION_DIR

if [ -z "${AWS_LAMBDA_RUNTIME_API}" ]; then
    exec /usr/bin/aws-lambda-rie /usr/bin/python3 -m awslambdaric $1
else
    exec /usr/bin/python3 -m awslambdaric $1
fi