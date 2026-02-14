output "instance_id" {
  value = aws_instance.ec2.id
}

output "public_ip" {
  value = aws_instance.ec2.public_ip
}

output "key_pair_used" {
  value = var.existing_key_pair_name
}
