# create a DB

provider "aws" {
  region = "us-east-2"
}

resource "aws_db_instance" "example_db" {
  identifier_prefix = "terraform-db"
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  name = var.db_name
  username = "admin"

  # how to set password
  # two options - ask terraform data source to read the secrets from a secret store
  # using AWS store manager - a managed service for storing sensitive data
  # AWS secret UI can be used to store the secret and then read the secret back in the code

 # password = data.aws_secretsmanager_secret_version.db_password.secret_string
 # above wont work cuz i cannot create below

 password  = var.db_password
 
}

#data "aws_secretsmanager_secret_version" "db_password" {
#  secret_id = "mysql-master-password-stage"
#}

# other options for above
# AWS system Manager parameter store can be used as below
#   aws_ssm_parameter   data source
# AWS Key management Service (AWS KMS)
#   aws_kms_secrets data source
# Google Cloud KMS
#   google_kms_secret data source
# Azure Key Vault
#   azurerm_key_vault_secret
# HashiCorp Vault
#    vault_generic_secret

# Second option is to use a Key manager 1Password, LastPass
# every variable can be extracted to a file varaibles.tf

# i jus moved it

# the password will be set in environment using export
# using dis command
#  export TF_VAR_db_password="(YOUR_DB_PASSWORD)"
# there is a space before export to avoid saving the password in bash history

# set up s3 bucket to save dis tf state too
terraform {
  backend "s3" {
    key = "prod/data-stores/mysql/terraform.tfstate"
    bucket = "usman-bucket"
    region = "us-east-2"

    # DynamoDB 
    dynamodb_table = "usman-table"
    encrypt = true
  }
}
