# Required Variables

variable "instance_key_name" {
  type        = string
  description = "Key for connecting to instance"
}

variable "project_name" {
  type        = string
  description = "Project name to use for resource naming and tags"
}

variable "ssh_source_address" {
  type        = string
  description = "CIDR range that will be allowed to SSH to instances"
}

# Optional Variables

variable "bastion_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "AWS Instance type for bastion host"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "AWS Instance type for Consul servers"
}

variable "key_name" {
  type        = string
  default     = "key"
  description = "Filename for SSH key"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region to deploy infrastructure"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "CIDR for AWS VPC"
}

variable "vpc_azs" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "CIDRs for private subnets"
}

variable "vpc_public_subnets" {
  type        = list(string)
  default     = ["10.0.1.192/26"]
  description = "CIDRs for private subnets"
}

variable "vpc_private_subnets" {
  type        = list(string)
  default     = ["10.0.1.0/26", "10.0.1.64/26", "10.0.1.128/26"]
  description = "CIDRs for private subnets"
}
