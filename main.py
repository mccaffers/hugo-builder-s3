## Hugo Builder and S3 Upload (hugo-builder-s3)
## By Ryan McCaffery (mccaffers.com)
##
## This code is licensed under Creative Commons Zero (CC0)
## You can copy, modify, distribute and perform the work, even for commercial purposes, all without asking permission.
## See LICENSE.md for more details
## ---------------------------------------

import json
import subprocess

def handler(event, context):
    subprocess.run('sh ./script.sh', shell=True)
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps({
            'success': True
        }),
        "isBase64Encoded": False
    }