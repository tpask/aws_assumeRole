#!/bin/bash
#e.g. source ./$0 1234567890 targetRole

# ****
# This script assumes that you already authenticated to your source account either via keys
# or running command on a resource (like ec2) that has a role with permissions to
# assume role on the target account.
# Note: source and target account can be one of the same.  If target and source are different,
# than this would be a cross account role access.
# ****

roleArn=arn:aws:iam::$1:role/$2 
unset AWS_SESSION_TOKEN AWS_SECRET_ACCESS_KEY AWS_ACCESS_KEY_ID
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
  $(aws sts assume-role --role-arn ${roleArn} \
  --role-session-name mysession \
  --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
  --output text))

# verify that you authenticated correctly to the desired destination role:
aws sts get-caller-identity
unset AWS_PROFILE
