output "aws_region" {
  description = "The AWS region where resources are deployed"
  value       = var.aws_region
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = var.cluster_name
}

output "kubeconfig_command" {
  description = "Command to configure kubectl for the EKS cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}"
}


