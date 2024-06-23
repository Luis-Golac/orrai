import json
import boto3
from boto3.dynamodb.conditions import Key
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('users')

class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, Decimal):
            return float(o)
        return super(DecimalEncoder, self).default(o)

def lambda_handler(event, context):
    try:
        if 'body' in event:
            body = json.loads(event['body'])
        else:
            body = event

        username = body.get('username')
        password = body.get('password')

        if not username or not password:
            return {
                'statusCode': 400,
                'body': json.dumps({'message': 'Username and password are required'})
            }

        response = table.query(
            IndexName='username-password-index',
            KeyConditionExpression=Key('username').eq(username) & Key('password').eq(password)
        )

        if response['Count'] == 0:
            return {
                'statusCode': 401,
                'body': json.dumps({'message': 'Invalid username or password'})
            }

        user_info = response['Items'][0]

        user_info.pop('password', None)

        response_body = {
            'user_id': user_info.get('user_id'),
            'username': user_info.get('username'),
            'phone_number': user_info.get('phone_number'),
            'email': user_info.get('email'),
            'favorites': user_info.get('favorites'),
            'latitude': user_info.get('latitude'),
            'longitude': user_info.get('longitude')
        }

        return {
            'statusCode': 200,
            **response_body
        }

    except KeyError as e:
        print("KeyError:", e)
        return {
            'statusCode': 400,
            'headers': {
                'Content-Type': 'application/json'
            },
            'message': f'Invalid request: missing key {str(e)}'
        }
    except Exception as e:
        print("Exception:", e)
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json'
            },
            'message': 'Internal Server Error'
        }
