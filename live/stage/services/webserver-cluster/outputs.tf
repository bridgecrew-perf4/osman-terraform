# pass thru the name of the DNS from module
output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
  description = "The domain name of the LB"
}