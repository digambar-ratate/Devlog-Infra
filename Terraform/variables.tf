variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "The type of instance to create"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "The name of the key-pair to use for the instance"
  type        = string
  default     = "Devlog"
}

variable "name" {
  description = "The name tag for the instance"
  type        = string
  default     = "DevLog-Docker-Server"
}