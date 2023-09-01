data "aws_vpc" "test_vpc" {
  filter {
    name   = "tag:Name"
    values = ["test-vpc"]
  }
}

data "aws_route_table" "default" {
  filter {
    name   = "tag:Name"
    values = ["Default"]
  }
}