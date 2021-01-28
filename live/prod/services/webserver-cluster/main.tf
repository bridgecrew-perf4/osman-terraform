# define provider here instead of inside the module
provider "aws" {
  region = "us-east-2"
}

# define the module

module "webserver_cluster" {
  #source = "/home/ussy/osman-terraform/modules/services/webserver-cluster"

  # using github source
  source = "github.com/osm1n/osman-terraform-modules//services/webserver-cluster?ref=v0.0.4"

  cluster_name = "webservers-prod"
  db_remote_state_bucket = "usman-bucket"
  db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"
  
  instance_type = "t2.micro" # can be m4.large
  min_size = 2
  max_size = 10
}

resource "aws_autoscaling_schedule" "scale_out_during_business" {
  scheduled_action_name = "scale-out-during-biz-hrs"
  min_size = 2
  max_size = 10
  desired_capacity = 10
  recurrence = "0 9 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name

}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size = 2
  max_size = 10
  desired_capacity = 2
  recurrence = "0 17 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name

}
