variable "region" {
  default = "us-east-2"
}
variable "amiid" {
  type = "map"
  default = {
    us-east-2 = "ami-0fc20dd1da406780b"
    us-east-1 = "ami-0400a1104d5b9caa1"
    us-west-1 = "ami-03ba3948f6c37a4b0"
  }
  description = "You may added more regions if you want"
}
#K8s Master instance count
variable "instance_count" {
default = "1"
}
#k8s Master instance type
variable "instance_type" {
  default = "t2.micro"
}
variable "key_name" {
  default = "srimul"
  description = "the ssh key to be used for the EC2 instance"
}

variable "instance_tags" {
  type = "list"
  default = ["Nginx-Webserver", "Tomcat-Appserver"]
}
variable "security_group" {
  default = "sg-0aaa3aac86f3cdc08"
  description = "Security groups for the instance"
}
variable "websubnet" {
  default = "subnet-0d5acf536cda4d943"
  }
# Host variables
variable "appsubnet" {
  default= "subnet-0dbbd4d635dd7cb21"
  }
variable "hostinstance_count" {
default = "1"
}
variable "hostinstance_type" {
  default = "t2.micro"
}
