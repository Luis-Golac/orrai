import json
import boto3
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('eventos')

def lambda_handler(event, context):
    try:
        if 'body' in event:
            data = json.loads(event['body'])
        else:
            data = event

        with table.batch_writer() as batch:
            for record in data:
                item = {
                    'evento_nombre': record['evento_nombre'],
                    'evento_fecha': record['evento_fecha'],
                    'evento_latitud': Decimal(str(record['evento_latitud'])),
                    'evento_longitud': Decimal(str(record['evento_longitud'])),
                    'evento_direccion': record['evento_direccion'],
                    'evento_detalles': record['evento_detalles'],
                    'user_id': record.get('user_id', None),
                    'confirmations': 0,
                    'denials': 0
                }
                batch.put_item(Item=item)

        return {
            'statusCode': 200,
            'body': json.dumps('Data successfully inserted into DynamoDB')
        }
    except Exception as e:
        print(f"Exception: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps(f"Internal Server Error: {e}")
        }
