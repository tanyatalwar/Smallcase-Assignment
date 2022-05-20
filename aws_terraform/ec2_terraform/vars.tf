---------------------------------
new var file

variable "AWS_ACCESS_KEY" {}
variable "AWS_ACCESS_KEY" {}
variable "AWS_ACCESS_KEY" {}







---------------------------------
variable "access_key_cred" {
    type = "string"    // export TF_VAR_access_key_cred="xxxxxxx"
}

variable "secret_key_cred" {
    type = "string"     // export TF_VAR_secret_key_cred="xxxxxxx"
}

variable "image_id" {
     default = "ami-08569b978cc4dfa10"
     type = "string"
}

variable "instance_type" {
     default = "t2.micro"
     type = "string"
}

variable "instanceTenancy" {
    default = "default"
}

variable "dnsSupport" {
    default = true
}
variable "dnsHostNames" {
    default = true
}

variable "subnetCIDRblock" {
    default = "10.0.1.0/24"
}

variable "mapPublicIP" {
    default = true
}

variable "availabilityZone" {
     default = "us-east-1a"
}