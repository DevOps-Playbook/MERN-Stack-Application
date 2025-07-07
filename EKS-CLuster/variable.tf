variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"

}
variable "project_name" {
  description = "The name of the project for naming resources"
  type        = string
  default     = "project"
}
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "project"
}
variable "instance_types" {
  description = "List of instance types for the EKS node group"
  type        = list(string)
  default     = ["t2.medium"]

}
variable "azs" {
  description = "List of availability zones to use for the VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    Project = "project"
    Owner   = "terraform"
  }
}
variable "node_group_name" {
  description = "The name of the EKS node group"
  type        = string
  default     = "project-node-group"
}