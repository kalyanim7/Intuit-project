provider "aws" {
   region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "intuitproject"
    key    = "Intuit-project/terraform.tfstate"
    region = "us-east-2"
  }
}
resource "aws_security_group" "allow_ssh" {
  name = "sg_Intuit"
  description = "Allow ssh inbound traffic"
  vpc_id = var.vpcid
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
 }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
module "webserver" {
  source = "../../modules/ec2"
  amiid = "${lookup(var.amiid, var.region)}"
  instance_type = var.instance_type
  instance_count = var.instance_count
  vpc_security_group_ids = aws_security_group.allow_ssh.id
  subnet_id = var.websubnet
  instance_tags ="${element(var.instance_tags,0)}"
  
  key_name = "${var.key_name}"

#  user_data = "${file("master.sh")}"
 }

output "master_public_ip" {
   value = "${formatlist("%v", module.webserver.*.server_public_ip)}"
}
module "Appserver" {
  source = "../../modules/ec2"
  amiid = "${lookup(var.amiid, var.region)}"
  instance_type = var.hostinstance_type
  instance_count = var.hostinstance_count
  vpc_security_group_ids = aws_security_group.allow_ssh.id
  subnet_id = var.appsubnet
  instance_tags ="${element(var.instance_tags,1)}"
  key_name = "${var.key_name}"

#  user_data = "${file("host.sh")}"
 }

output "public_ip" {
   value = "${formatlist("%v", module.Appserver.*.server_public_ip)}"
}

resource "null_resource" "myPublicIps" {
#count = var.instance_count

provisioner "local-exec" {
command =  "echo 'Webserver' > hosts1"
}
provisioner "local-exec" {
 command = "echo '${element(module.webserver.server_public_ip.*,0)}' >> hosts1"
 }
provisioner "local-exec" {
    command=  "echo 'Appserver' >> hosts1"
}
provisioner "local-exec" {
     command = "echo '${element(module.Appserver.server_public_ip.*,0)}' >> hosts1"
 }
provisioner "local-exec" {
 command = "aws ec2 wait instance-status-ok --instance-ids '${element(module.Appserver.server_instance_id.*,0)}' --region us-east-2"
 }
provisioner "local-exec" {
 command = "aws ec2 wait instance-status-ok --instance-ids '${element(module.Webserver.server_instance_id.*,0)}'"
 }
   
}
