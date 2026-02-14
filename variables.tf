variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "allowed_ssh_cidr" {
  description = "Allowed IP for SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "existing_key_pair_name" {
  description = "Existing AWS Key Pair Name"
  type        = string
}
