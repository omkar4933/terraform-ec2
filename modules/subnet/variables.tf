variable "vpc_id" {
  description = "ID of VPC"
  type        = string
}

variable "availability_zone" {
  description = "availability_zone name."
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for subnet"
  type        = string
}

variable "tags" {
  description = "Key Value map of tags"
  type        = map(any)
  default     = {}
}


variable "route_table_id" {
  description = "he ID of the routing table to associate with."
  type = string
}