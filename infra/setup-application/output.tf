output "elb_dns" {
    value = "${aws_elb.helloawsnode_elb.dns_name}"
}
