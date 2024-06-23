import json
import boto3
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

        user_id = body.get('user_id')
        latitude = Decimal(str(body.get('latitude')))
        longitude = Decimal(str(body.get('longitude')))

        if not user_id or latitude is None or longitude is None:
            return {
                'statusCode': 400,
                'body': json.dumps({'message': 'User ID, latitude, and longitude are required'})
            }

        response = table.update_item(
            Key={
                'user_id': user_id
            },
            UpdateExpression="set latitude = :lat, longitude = :lon",
            ExpressionAttributeValues={
                ':lat': latitude,
                ':lon': longitude
            },
            ReturnValues="UPDATED_NEW"
        )

        return {
            'statusCode': 200,
            'body': json.dumps(
                {
                    'message': 'User location updated successfully',
                    'updatedAttributes': response['Attributes']}, cls=DecimalEncoder
            )
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
