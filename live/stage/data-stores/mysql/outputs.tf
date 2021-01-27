# Add Address and port for DB
output "address" {
  value = aws_db_instance.example_db.address
  description = "Connect to the DB at this endpoint"
}

# port 
output "port" {
  value = aws_db_instance.example_db.port
  description = "The port of DB listening"
}