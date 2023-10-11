roleArn=$1  #e.g. arn:aws:iam::123456789012:role/targetRoleName

# ****
# This script assumes that you already authenticated to your source account either via keys
# or running command on a resource (like ec2) that has a role with permissions to
# assume role on the target account.
# Note: source and target account can be one of the same.  If target and source are different,
# than this would be a cross account role access.
# ****

export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
  $(aws sts assume-role --role-arn ${roleArn} \
  --role-session-name mysession \
  --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]"
  --output text))

# verify that you authenticated correctly to the desired destination role:
aws sts get-caller-identity
