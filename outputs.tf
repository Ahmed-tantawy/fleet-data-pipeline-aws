output "ansible_target_public_ip" {
  description = "Public IP of the Ansible target instance"
  value       = aws_instance.ansible_target.public_ip
}

output "ansible_private_key" {
  description = "Private key for SSH access to the Ansible target"
  value       = tls_private_key.ansible_ssh.private_key_pem
  sensitive   = true
}
