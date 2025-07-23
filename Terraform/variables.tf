variable "region" {
  default = "ap-south-1"
}

variable "bucket_name" {
  default = "ashrith-devops-app-logs"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  default = "ashrith"
}

variable "ami_id" {
  default = "ami-0f5ee92e2d63afc18" # Ubuntu 22.04 in ap-south-1
}

variable "stage" {
  default = "dev"
}
