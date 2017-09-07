output "primary_public_subnet" {
  value = "${aws_subnet.primary_public.id}"
}
output "primary_private_subnet" {
  value = "${aws_subnet.primary_private.id}"
}
output "secondary_public_subnet" {
  value = "${aws_subnet.secondary_public.id}"
}
output "secondary_private_subnet" {
  value = "${aws_subnet.secondary_private.id}"
}
output "vpc" {
  value = "${aws_vpc.platform_vpc.id}"
}


