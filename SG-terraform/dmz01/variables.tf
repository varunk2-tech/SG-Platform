variable "dmz_subnet" {
  default = "subnet-d353d6b4"
}

variable "dmz_security_group" {
  default = "sg-0d6a2884d294dfeed"
}

variable "eip" {
  default = "eipalloc-0c6d9a282958ae256"
}

variable "ami_id" {
  default = "ami-68860608"
}

variable "kms_key_id" {
  default = "arn:aws:kms:us-west-2:886316083336:key/44660780-ef6f-4cd2-96d5-ea75ea85613b"
}

variable "instance_types" {
  default = "t2.medium"
}

variable "availability-zones" {
  default = "us-west-2a"
}

variable "key" {
  default = "nimbus-init"
}

variable "add_public_ip_address" {
  default = "true"
}

variable "root_volume_size" {
  default = "8"
}

variable "root_volume_type" {
  default = "gp2"
}

variable "swap_volume_type" {
  default = "gp2"
}

variable "swap_volume_size" {
  default = "2"
}

variable "swap_volume_name" {
  default = "dmz01.us8-test_swap"
}

variable "kms_encryption_enable" {
  default = "true"
}

variable "terminate" {
  default = "true"
}

variable "hostname" {
  default = "dmz01.us8-test"
}

variable "privateip" {
  default = "10.31.8.57"
}

#variable "count1" {
#  default = "1"
#}

variable "swap_volume_devicename" {
  default = "/dev/xvdb"
}
