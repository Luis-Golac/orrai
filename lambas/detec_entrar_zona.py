import json
import boto3

sns_client = boto3.client('sns')

def lambda_handler(event, context):
    try:
        for record in event['Records']:
            detail = json.loads(record['body'])
            event_type = detail['EventType']
            position = detail['Position']
            device_id = detail['DeviceId']
            geofence_id = detail['GeofenceId']

            message = f"Device {device_id} has {event_type.lower()}ed geofence {geofence_id} at position (lat: {position['Latitude']}, lon: {position['Longitude']})."

            response = sns_client.publish(
                TopicArn='arn:aws:sns:us-west-2:639901084655:Notificar_Evento_SMS',
                Message=message,
                Subject=f'Geofence {event_type}'
            )
            print(f"SNS publish response: {response}")
        return {
            'statusCode': 200,
            'body': json.dumps('Notification sent successfully')
        }
    except Exception as e:
        print(f"Exception: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps(f"Internal Server Error: {e}")
        }
