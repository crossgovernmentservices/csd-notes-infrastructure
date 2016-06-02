import json
import urllib
import boto3
import email
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3 = boto3.client('s3')


def lambda_handler(event, context):
    logger.info("Received event: " + json.dumps(event, indent=2))

    # Unwrap S3 event from SNS event container
    sns_msg = json.loads(event['Records'][0]['Sns']['Message'])

    # Get S3 bucket and key name from SNS message
    bucket_name = sns_msg['Records'][0]['s3']['bucket']['name']
    key_name = urllib.unquote_plus(sns_msg['Records'][0]['s3']['object']['key']).decode('utf8')

    # Get raw message from S3
    obj = s3.get_object(Bucket=bucket_name, Key=key_name)
    raw_msg = obj['Body'].read().decode('utf8')

    msg = email.message_from_string(raw_msg)

    # very quick and dirty attachment saving
    for part in msg.walk():
        if part.get_content_maintype() == 'multipart':
            continue

        # If part has a filename it's probably an attachment
        if part.get_filename():
            # save to S3_BUCKET:attachments/EMAIL_ID/ATTACHMENT_FILENAME
            email_id = key_name.split('/')[1]
            att_key = "attachments/{}/{}".format(email_id, part.get_filename())

            s3.put_object(Bucket=bucket_name, Key=att_key,
                Body=part.get_payload(decode=True),
                ContentType=part.get_content_type(),
                ContentDisposition=part.get('Content-Disposition'))

            logger.info('Saved attachment: {}:{} ()'.format(
                bucket_name, att_key, part.get_content_type()))
