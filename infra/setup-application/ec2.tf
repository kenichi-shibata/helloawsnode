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
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

data "aws_ami" "helloawsnode_ami" {
  most_recent = true
 # filter {
 #   name = "image_id" 
 #   values = ["${file("${path.module}/../../ami-out.file")}"]
 # }
  
  #filter {
  #  name = "description"
  #  values = ["test"]
  #}
  
  filter {
    name = "tag-value"
    values = ["*helloawsnode*"]
  }
}
resource "aws_launch_configuration" "as_conf" {
  name          = "helloawnode_launch_conf"
  image_id      = "${data.aws_ami.helloawsnode_ami.image_id}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.allow_ssh.id}","${aws_security_group.allow_http.id}"]
}


