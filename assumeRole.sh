#!/bin/bash
# Usage:
#
# assumeRole ${sourceProfile} ${targetAccountId} ${targetRole}
# aws sts get-caller-identity --profile ${TARGET_PROFILE}

sourceProfile=$1
targetAccountId=$2
targetRole=$3

assumeRole() {
  targetRoleArn=arn:aws:iam::${targetAccountId}:role/${targetRole}
  targetProfile="${targetAccountId}-${targetRole}"

  sts=$(aws sts assume-role --profile ${sourceProfile} --role-arn "${targetRoleArn}" --role-session-name "${targetRole}" \
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
assumeRole ${sourceProfile} ${targetAccountId} ${targetRole}
