terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.7"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.2.2"
    }
  }
}
