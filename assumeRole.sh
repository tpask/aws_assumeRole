#!/bin/bash
# Usage:
#
# assumeRole ${TARGET_ROLE_ARN} ${TARGET_PROFILE}
# aws sts get-caller-identity --profile ${TARGET_PROFILE}

assumeRole() {
  ROLE_ARN=$1
  OUTPUT_PROFILE=$2

  echo "Assuming role $ROLE_ARN"
  sts=$(aws sts assume-role \
    --role-arn "$ROLE_ARN" \
    --role-session-name "$OUTPUT_PROFILE" \
    --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
    --output text)
  echo "Converting sts to array"
  sts=($sts)
  echo "AWS_ACCESS_KEY_ID is ${sts[0]}"
  aws configure set aws_access_key_id ${sts[0]} --profile $OUTPUT_PROFILE
  aws configure set aws_secret_access_key ${sts[1]} --profile $OUTPUT_PROFILE
  aws configure set aws_session_token ${sts[2]} --profile $OUTPUT_PROFILE
  echo "credentials stored in the profile named $OUTPUT_PROFILE"
}

TARGET_ROLE_ARN=$1
TARGET_PROFILE=$2
assumeRole ${TARGET_ROLE_ARN} ${TARGET_PROFILE}
aws sts get-caller-identity --profile ${TARGET_PROFILE}
