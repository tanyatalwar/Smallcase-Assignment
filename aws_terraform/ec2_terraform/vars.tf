variable "AWS_ACCESS_KEY" {
     type = "string" // export TF_VAR_AWS_ACCESS_KEY="xxxxxxx"
}

variable "AWS_REGION" {
     type = "string" // export TF_VAR_AWS_REGION="xxxxxxx"
}

variable "AWS_SECRET_KEY" {
     type = "string" // export TF_VAR_AWS_SECRET_KEY="xxxxxxx"
}

variable "image_id" {
     default = "ami-08569b978cc4dfa10"
     type = "string"
}

variable "instance_type" {
     default = "t2.micro"
     type = "string"
}

variable "availabilityZone" {
     default = "us-east-1a"
}
