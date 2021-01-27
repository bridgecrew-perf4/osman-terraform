# define provider here instead of inside the module
provider "aws" {
  region = "us-east-2"
}

# define the module

module "webserver_cluster" {
  source = "/home/ussy/osman-terraform/modules/services/webserver-cluster"

  cluster_name = "webservers-stage"
  db_remote_state_bucket = "usman-bucket"
  db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
  
  instance_type = "t2.micro" # can be m4.large
  min_size = 2
  max_size = 2
}

# jus testing opening a random port 
# dis refers back to the not using inline blocks

resource "aws_security_group_rule" "allow_test_inbound" {
  type = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port = 4567
  to_port = 4567
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}