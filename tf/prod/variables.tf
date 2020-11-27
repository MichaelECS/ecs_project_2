variable "region" {
    type = string
    default = "eu-west-1"
}
variable "ami" {
    type = string
    default = "ami-014ce76919b528bff"
}
variable "instance_type" {
    type = string
    default = "t2.micro"
}
variable "vpcCIDRblock" {
    type = string
    default = "10.0.0.0/16"
}
variable "subnetOneCIDRblock" {
    type = string
    default = "10.0.1.0/24"
}
variable "subnetTwoCIDRblock" {
    type = string
    default = "10.0.2.0/24"
}
variable "destinationCIDRblock" {
    type = string
    default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
    type = list(string)
    default = [ "0.0.0.0/0" ]
}
variable "egressCIDRblock" {
    type = list(string)
    default = [ "0.0.0.0/0" ]
}
variable "mapPublicIP" {
    type = bool
    default = "true"
}
variable "availabilityZoneOne" {
    type = string
    default = "eu-west-1a"
}
variable "availabilityZoneTwo" {
    type = string
    default = "eu-west-1b"
}

variable "http_port" {
    type = string
    default = "80"
}

variable "container_cpu" {
    type = string
    default = "256"
}

variable "container_memory" {
    type = string
    default = "1024"
}