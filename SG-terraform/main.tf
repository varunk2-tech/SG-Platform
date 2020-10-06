provider "aws" {
        access_key = "${var.access_key}"
        secret_key = "${var.secret_key}"
        region     = "${var.region}"
}

module "app01" {
 source = "./app01"
}

module "backup01" {
 source = "./backup01"
}

module "dmz01" {
 source = "./dmz01"
}

module "data01" {
 source = "./data01"
}
