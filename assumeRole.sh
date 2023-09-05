#!/bin/bash
# Usage:
#
# assumeRole ${targetAccountId} ${targetRole}
# aws sts get-caller-identity --profile ${TARGET_PROFILE}

targetAccountId=$1
targetRole=$2

assumeRole() {
  targetRole=$2
  targetAccountId=$1
  targetRoleArn=arn:aws:iam::${targetAccountId}:role/${targetRole}
  targetProfile="${targetAccountId}-${targetRole}"

  sts=$(aws sts assume-role --role-arn "${targetRoleArn}" --role-session-name "${targetRole}" \
    --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' --output text)
    
  if [ $? -eq 0 ]; then
    sts=($sts)
    echo "AWS_ACCESS_KEY_ID is ${sts[0]}"
    aws configure set aws_access_key_id ${sts[0]} --profile ${targetProfile}
    aws configure set aws_secret_access_key ${sts[1]} --profile ${targetProfile}
    aws configure set aws_session_token ${sts[2]} --profile ${targetProfile}
    echo "credentials stored in the profile: ${targetProfile}"
  else
   echo "Error: $?"
   echo "Not able to assume Role"
  fi
}
assumeRole ${targetAccountId} ${targetRole}
