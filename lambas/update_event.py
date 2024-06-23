import json
import boto3

from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('eventos')

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

        evento_name = body.get('evento_nombre')

        evento_date = body.get('evento_fecha')
        accion = body.get('accion')

        if accion:
            update_expression = "SET confirmations = if_not_exists(confirmations, :start) + :inc"
        else:
            update_expression = "SET denials = if_not_exists(denials, :start) + :inc"

        expression_attribute_values = {
            ':inc': 1,
            ':start': 0
        }

        response = table.update_item(
            Key={
                'evento_nombre': evento_name,
                'evento_fecha': evento_date
            },
            UpdateExpression=update_expression,
            ExpressionAttributeValues=expression_attribute_values,
            ReturnValues="UPDATED_NEW"
        )

        return {
            'statusCode': 200,
            'body': json.dumps(
                {
                    'message': 'Counters updated successfully',
                    'updatedAttributes': response.get('Attributes')}, cls=DecimalEncoder)
        }
    except Exception as e:
        print("Exception:", e)
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Internal Server Error: ' + str(e)})
        }
