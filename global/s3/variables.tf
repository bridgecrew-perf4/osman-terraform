# variable for bucket name
variable "bucket_name" {
  description = "S3 bucket name for all remote states"
  type = string
  default = "usman-bucket"

}

# variable for table name (dynamoDB)
variable "table_state_name" {
  description = "S3 table name for state keys. dynamoDB is used here"
  type = string
  default = "usman-table"
}