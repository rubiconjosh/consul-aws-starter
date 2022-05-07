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
