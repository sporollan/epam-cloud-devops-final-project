aws s3 rm s3://sporollan-state-bucket-3245 --recursive
aws s3api delete-bucket --bucket sporollan-state-bucket-3245
aws dynamodb delete-table \
  --table-name terraform-state-locks \
  --region us-east-1

