resource aws_instance "server" {
  count                   = "${length(var.servers)}"
  ami                     = "${var.server_image}"
  instance_type           = "${lookup(var.servers[count.index], "server_instance_type")}"
  subnet_id               = "${var.subnet_options[lookup(var.servers[count.index], "subnet_index")]}"
  key_name                = "g2-access"
  vpc_security_group_ids  = ["${var.security_groups}"]
  source_dest_check       = false
  root_block_device {
    volume_size           = "${lookup(var.servers[count.index], "volume_size", 20)}"
    volume_type           = "gp2"
    delete_on_termination = true
  }
  tags {
    Name        = "${lookup(var.servers[count.index], "server_name")}"
    Environment = "${var.environment}"
#    Service    = "${var.service}"
  }
  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname "${lookup(var.servers[count.index], "server_name")}"
    yum update -y
    reboot
    EOF
}
