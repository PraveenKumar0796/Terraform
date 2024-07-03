
module "Web-server" {
  source = "./module-WEB"
  
}

terraform {
  backend "s3" {
    bucket         = "terraform0123tf"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }
}

output "LB_DNS_NAME" {
  value = module.Web-server.load_balancer_dns
}