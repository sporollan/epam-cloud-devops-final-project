aws s3api create-bucket \
  --bucket sporollan-state-bucket-3245 \
  --region us-east-1

aws s3api put-bucket-versioning \
  --bucket sporollan-state-bucket-3245 \
  --versioning-configuration Status=Enabled

aws dynamodb create-table \
  --table-name terraform-state-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
