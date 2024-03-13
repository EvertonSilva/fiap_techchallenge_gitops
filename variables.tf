variable "aws_region" {
  description = "AWS Access Key"
  default = "us-east-1"
  type = string
}

variable "tfstate_bucket_name" {
  description = "Bucket para armazenar tfstate"
  default = "postech-iac-state"
  type = string
}
