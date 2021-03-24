output "aws_client_ssh_access" {
  description = "Linux command to ssh aws client"
  value       = format("ssh -p %s ec2-user@%s", var.client_ssh_port, data.aws_instance.ce.public_dns)
}
