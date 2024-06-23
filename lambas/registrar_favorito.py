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
        user_id_favorite = body.get('user_id_favorite')

        response = table.get_item(
            Key={'user_id': user_id},
            ProjectionExpression='favorites'
        )

        update_response = table.update_item(
            Key={
                'user_id': user_id
            },
            UpdateExpression="SET favorites = list_append(if_not_exists(favorites, :empty_list), :new_favorite)",
            ExpressionAttributeValues={
                ':new_favorite': [user_id_favorite],
                ':empty_list': []
            },
            ReturnValues="UPDATED_NEW"
        )

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Favorite added successfully',
                'updatedFavorites': update_response['Attributes'].get('favorites')},
                cls=DecimalEncoder
            )
        }
    except Exception as e:
        print("Exception:", e)
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Internal Server Error: ' + str(e)})
        }
