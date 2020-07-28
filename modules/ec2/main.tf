provider "aws" {
   region = "us-east-2"
}
## This is a way to return values from a modules
output "k8s_public_ip" {
  value = "${aws_instance.cZServers.*.public_ip}"
}
output "k8s_instance_id" {
  value = "${aws_instance.cZServers.*.id}"
}

resource "aws_instance" "cZServers" {
  ami = var.amiid
  instance_type = var.instance_type
  count = var.instance_count
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  subnet_id = var.subnet_id
  tags = {
    Name  = "${var.instance_tags}-${count.index + 1}"
  }

  key_name = var.key_name

}
