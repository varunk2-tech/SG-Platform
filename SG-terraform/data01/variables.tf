variable "data_subnet" {
        default = "subnet-4b52d72c"
}

variable "data_security_group" {
        default = "sg-0911892d44a7fa338"
}

variable "ami_id" {
  default = "ami-68860608"
}

variable "role_id" {
  default = "artemis-role"
}

variable "kms_key_id" {
  default = "arn:aws:kms:us-west-2:886316083336:key/44660780-ef6f-4cd2-96d5-ea75ea85613b"
}

variable "instance_varity" {
  default = "m4.large"
}

variable "availability_zones" {
  default = "us-west-2a"
}

variable "key" {
  default = "nimbus-init"
}

variable "kms_encryption_enable" {
  default = "true"
}

variable "add_public_ip_address" {
  default = "false"
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

variable "swap_volume_name" {
  default = "data01.us8-test_swap"
}

variable "swap_volume_size" {
  default = "2"
}

variable "swap_volume_devicename" {
  default = "/dev/xvdb"
}

variable "nfs_volume_type" {
  default = "gp2"
}

variable "nfs_volume_name" {
  default = "data01.us8-test_nfs"
}

variable "nfs_volume_size" {
  default = "500"
}

variable "nfs_volume_devicename" {
  default = "/dev/xvdc"
}

variable "db_volume_type" {
  default = "gp2"
}

variable "db_volume_name" {
  default = "data01.us8-test_db"
}

variable "db_volume_size" {
  default = "500"
}

variable "db_volume_devicename" {
  default = "/dev/xvdd"
}

variable "terminate" {
  default = "true"
}

variable "root_volume_delete" {
  default = "false"
}

variable "hostname" {
  default = "data01.us8-test"
}

variable "privateip" {
  default = "10.31.10.62"
}