import json
import boto3
import uuid
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('users')

def lambda_handler(event, context):
    try:
        if 'body' in event:
            body = json.loads(event['body'])
        else:
            body = event

        username = body.get('username')
        password = body.get('password')
        phone_number = body.get('phone_number')
        email = body.get('email')
        latitude = Decimal(str(body.get('latitude', 0.0)))
        longitude = Decimal(str(body.get('longitude', 0.0)))
        favorites = body.get('favorites', [])

        if not username or not password or not phone_number or not email:
            return {
                'statusCode': 400,
                'body': json.dumps({
                    'message': 'Username, password, phone number, and email are required'
                })
            }

        user_id = str(uuid.uuid4())

        item = {
            'user_id': user_id,
            'username': username,
            'password': password,
            'phone_number': phone_number,
            'email': email,
            'latitude': latitude,
            'longitude': longitude,
            'favorites': favorites
        }

        table.put_item(Item=item)
        return {
            'statusCode': 201,
            'body': json.dumps({'message': 'User registered successfully', 'user_id': user_id})
        }
    except KeyError as e:
        print("KeyError:", e)
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'Invalid request: missing key ' + str(e)})
        }
    except Exception as e:
        print("Exception:", e)
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Internal Server Error'})
        }
