resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh"
  description = "Allow all ssh inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

}

resource "aws_security_group" "allow_http" {
  name        = "allow-http"
  description = "Allow all http inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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
  name          = "${var.application_name}-launch-conf"
  image_id      = "${data.aws_ami.helloawsnode_ami.image_id}"
  instance_type = "${var.instance_type}"
  security_groups = ["${aws_security_group.allow_ssh.id}","${aws_security_group.allow_http.id}"]
  associate_public_ip_address = true
}


resource "aws_autoscaling_group" "helloawsnode_asg" {
  name                      ="${var.application_name}-asg"
  max_size                  = 6
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true 
  launch_configuration      = "${aws_launch_configuration.as_conf.name}"
  load_balancers            = ["${aws_elb.helloawsnode_elb.id}"]
  vpc_zone_identifier       = ["${var.primary_subnet}", "${var.secondary_subnet}" ]
  
  tags  {
    key    = "Name"
    value  = "${var.application_name}-asg"
    propagate_at_launch = true
  }
}

# TODO use alb instead for reusability when running multi ports

resource "aws_elb" "helloawsnode_elb" {
  name            = "${var.application_name}-elb"
  subnets         = ["${var.primary_subnet}", "${var.secondary_subnet}" ]
  security_groups = ["${aws_security_group.allow_http.id}"]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


  health_check {
    healthy_threshold   = 4 
    unhealthy_threshold = 4
    timeout             = 20
    target              = "HTTP:80/"
    interval            = 300
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "${var.application_name}-elb"
  }
}
