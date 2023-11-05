#!/bin/sh

## Hugo Builder and S3 Upload (hugo-builder-s3)
## By Ryan McCaffery (mccaffers.com)
##
## This code is licensed under Creative Commons Zero (CC0)
## You can copy, modify, distribute and perform the work, even for commercial purposes, all without asking permission.
## See LICENSE.md for more details
## ---------------------------------------

set -x
cd $FUNCTION_DIR

if [ -z "${AWS_LAMBDA_RUNTIME_API}" ]; then
    exec /usr/bin/aws-lambda-rie /usr/bin/python3 -m awslambdaric $1
else
    exec /usr/bin/python3 -m awslambdaric $1
fi