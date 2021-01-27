# connecting to S3 bucket
# saving tfstate file to avoid issues such as
# Manual errors, Locking and Plain secrets

provider "aws" {
  region = "us-east-2"
}

# create S3 Bucket

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  # prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }

  # enable versioning so we can see full version
  # history of the state file so we can have different
  # versions of the file, if shit happens we can revert to an old file

  versioning {
    enabled = true
  }

  # enable server side encryption by default
  # also provides encryption on disk

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# Use DynamoDB for locking - AWs distributed key-value store
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.table_state_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Add the remote backend to inform terraform to move state file to
# S3 Bucket
terraform {
  backend "s3" {
    bucket = "usman-bucket"
    key = "global/s3/terraform.tfstate"
    region = "us-east-2"

    # add DynamoDB Table
    dynamodb_table = "usman-table"
    encrypt = true
  }
}

# Am not using dis below using the one above
# Partial configuration. The other settings (e.g., bucket, region) will be #
# passed in from a file via -backend-config arguments to 'terraform init' terraform
# instead of using above code now split into two files
#terraform {
#  backend "s3" {
 #   key = "global/s3/terraform.tfstate "
 # }
#}