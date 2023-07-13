resource "aws_key_pair" "deployer" {
  count = var.ec2_enabled || var.lt_enabled || var.pem_enabled ? 1 : 0 
  key_name   = "${local.tag_name}-deployer-key"
  public_key = tls_private_key.pem[0].public_key_openssh
}

resource "tls_private_key" "pem" {
  count = var.ec2_enabled || var.lt_enabled || var.pem_enabled ? 1 : 0 
  algorithm   = "RSA"
  rsa_bits = "4096"
}

////

//resource "aws_key_pair" "template" {
//  key_name   = "launch-template-key"
//  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDusIvuj2Q5qOnTeEAGGMGtJ4U872Aom5exWjc/UVk0pZFQD4+5B1E8L053KIeGhtYTrsBlOnoab0asfAJnyxP5/Bf13WoHk1y4/++9Pje1pe1pPWITpifxYN0syD1EnXzrHGOlHP91TSBv55v/MAI3XaHWTeD6dGOeJysRRNXJiLGWkkGt0SMEBFaoalCYaiujQLUTi9UVIHeKzKkmwczI+PfNL6Jy7pPppJLfE4LlM4bi925WizQK5cjRW4YedmJ9D2R/klIpedt04DtCk2ZF0I6YAJoLEXof/h3J+rpvPRn8qIQx3YZyyCeWA+WCc/K6cxZFFLPWZ6v9v21wwuLDvRVbOdIIg4NB2K6WQawokpjAcPjobyEINtbOWNAHaekCV/Ok9fVcugzAgRQOULGTDFw56MPDMeXgwexzYnAWSXoYs1H/YyAQr9X8/1nocPsGzT0HSMwGdGFySxwQ+Lhz94JfOjIi7x42BGpHv2F4gnlTRNPjUGVHm0eZWxsgALE= ubuntu@ip-10-0-1-193"
//}
