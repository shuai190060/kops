variable "region" {
  default = "us-east-1"

}

variable "vpc_cidr" {
  default = "10.4.0.0/16"

}

variable "public_cidrblock_1" {
  default = "10.4.0.0/24"
}

variable "public_cidrblock_2" {
  default = "10.4.1.0/24"

}

variable "av_zone" {
  default = ["us-east-1a","us-east-1b"]

}

variable "tags" {
  description = "Tags for the resource"
  type        = map(string)
  default = {
    "Name" = "kops"
  }
}
