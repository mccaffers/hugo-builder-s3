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