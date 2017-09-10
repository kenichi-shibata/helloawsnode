resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow all ssh inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow all http inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_launch_configuration" "as_conf" {
  name          = "asg_launch_conf"
  image_id      = "${file("ami-out.file")}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.allow_ssh.id}","${aws_security_group.allow_http.id}"]
}


