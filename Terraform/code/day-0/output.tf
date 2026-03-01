output "public_ip" {
  value = aws_instance.TF-instance.public_ip
}

output "instance_id" {
    value = aws_instance.TF-instance.id
}