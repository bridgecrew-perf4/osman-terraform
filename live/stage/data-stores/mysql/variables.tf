# DB password
variable "db_password" {
   description = "The DB password"
   type = string
}

# DB Name
variable "db_name" {
  description = "The database name"
  type = string
  default = "usman_db_stage"
}