resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh"
  description = "Allow all ssh inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "allow_http" {
  name        = "allow-http"
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
  
  filter {
    name = "tag-value"
    values = ["*helloawsnode*"]
  }
}
resource "aws_launch_configuration" "as_conf" {
  name          = "helloawnode-launch-conf"
  image_id      = "${data.aws_ami.helloawsnode_ami.image_id}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.allow_ssh.id}","${aws_security_group.allow_http.id}"]
  associate_public_ip_address = true
}


resource "aws_autoscaling_group" "bar" {
  name                     = "helloawsnode-asg"
  max_size                  = 6
  min_size                  = 2
  health_check_grace_period = 120
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true 
  launch_configuration      = "${aws_launch_configuration.as_conf.name}"
  load_balancers            = "${aws_elb.helloawsnode_elb.id}"
  vpc_zone_identifier       = ["file("$path.module")/../../primary-public-out.file", "file("$path.module")/../../secondary-public-out.file"]
}

# TODO use alb instead for reusability when running multi ports
resource "aws_elb" "helloawsnode_elb" {
  name               = "helloawsnode-elb"
  availability_zones = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/health"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "helloawsnode-elb"
  }
}