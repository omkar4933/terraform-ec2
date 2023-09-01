variable "availability_zone" {
  description = "availability_zone name."
  type        = string
  default     = "ap-south-1a"
}

variable "cidr_block" {
  description = "CIDR block for subnet"
  type        = string
  default     = "172.31.0.0/16"
}

variable "cidr_block1" {
  description = "CIDR block for subnet"
  type        = string
  default     = "172.31.48.0/20"
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance"
  type        = string
  default     = "windows-19-base-aws"
}

variable "ami_id" {
  description = "AMI to use for the instance."
  type        = string
  default     = "ami-0d951b011aa0b2c19"
}

variable "my_ip" {
  type    = string
  default = "182.48.214.82/32"
}
