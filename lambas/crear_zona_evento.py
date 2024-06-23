import json
import boto3
from decimal import Decimal
import re

dynamodb = boto3.resource('dynamodb')
location = boto3.client('location')

def lambda_handler(event, context):
    try:
        for record in event['Records']:
            if record['eventName'] == 'INSERT':
                new_image = record['dynamodb']['NewImage']
                evento_nombre = new_image['evento_nombre']['S']
                evento_latitud = Decimal(new_image['evento_latitud']['N'])
                evento_longitud = Decimal(new_image['evento_longitud']['N'])
                evento_fecha = new_image['evento_fecha']['S']
                evento_id = re.sub(r'[^-._\w]', '_', evento_nombre + "-" + evento_fecha)
                create_geofence(evento_id, float(evento_latitud), float(evento_longitud))
        return {
            'statusCode': 200,
            'body': json.dumps('Geofences created successfully')
        }
    except Exception as e:
        print(f"Exception: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps(f"Internal Server Error: {e}")
        }

def create_geofence(geofence_id, lat, lon):
    response = location.put_geofence(
        CollectionName='event_geofence',
        GeofenceId=geofence_id,
        Geometry={
            'Polygon': [
                [
                    [lon - 0.05, lat - 0.05],
                    [lon + 0.05, lat - 0.05],
                    [lon + 0.05, lat + 0.05],
                    [lon - 0.05, lat + 0.05],
                    [lon - 0.05, lat - 0.05]
                ]
            ]
        }
    )
    print(f"Geofence created: {geofence_id}")
