provider "aws" {
   region = "us-east-2"
}
## This is a way to return values from a modules
output "server_public_ip" {
  value = "${aws_instance.cZServers.*.public_ip}"
}
output "server_instance_id" {
  value = "${aws_instance.cZServers.*.id}"
}

resource "aws_instance" "cZServers" {
  ami = var.amiid
  instance_type = var.instance_type
  count = var.instance_count
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  tags = {
    Name  = "${var.instance_tags}-${count.index + 1}"
  }

  key_name = var.key_name
 # provisioner "file" {
 #   source      = "/home/vidya/srimul.pem"
 #   destination = "/tmp/srimul.pem"
 # }
 # connection {
 #   host     = self.public_ip
 #   type     = "ssh"
 #   user     = "ubuntu"
 #   password = ""
 #   private_key = "${file("~/srimul.pem")}"
#}
}
