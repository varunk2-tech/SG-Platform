resource "aws_instance" "us8_test_data_instance" {
  ami = "${var.ami_id}"
  instance_type = "${var.instance_varity}"
  availability_zone = "${var.availability_zones}"
  subnet_id = "${var.data_subnet}"
  iam_instance_profile = "${var.role_id}"
  disable_api_termination = "${var.terminate}"
  security_groups = ["${var.data_security_group}"]
  user_data = "${file("/root/terraform/data01/data-puppet.sh")}"
  private_ip = "${var.privateip}"
  associate_public_ip_address = "${var.add_public_ip_address}"
  tags = {
    #Key = "Name"
    Name = "${var.hostname}"
    #Value = "${var.instance_name}"
       }
  key_name = "${var.key}"
  root_block_device {
    volume_size           = "${var.root_volume_size}"
    volume_type           = "${var.root_volume_type}"
    delete_on_termination = "${var.root_volume_delete}"
  }
}

resource "aws_ebs_volume" "swapvolume" {
    availability_zone = "${var.availability_zones}"
    type           = "${var.swap_volume_type}"
    encrypted = "${var.kms_encryption_enable}" 
    kms_key_id        = "${var.kms_key_id}"
    size = "${var.swap_volume_size}"
    tags = {
    Name = "${var.swap_volume_name}"
  }
}

resource "aws_volume_attachment" "ebs_swap" {
  device_name = "${var.swap_volume_devicename}"
  volume_id   = "${aws_ebs_volume.swapvolume.id}"
  instance_id = "${aws_instance.us8_test_data_instance.id}"
}

resource "aws_ebs_volume" "nfsvolume" {
    availability_zone = "${var.availability_zones}"
    type           = "${var.nfs_volume_type}"
    encrypted = "${var.kms_encryption_enable}" 
    kms_key_id        = "${var.kms_key_id}"
    size = "${var.nfs_volume_size}"
    tags = {
    Name = "${var.nfs_volume_name}"
  }
}

resource "aws_volume_attachment" "ebs_nfs" {
  device_name = "${var.nfs_volume_devicename}"
  volume_id   = "${aws_ebs_volume.nfsvolume.id}"
  instance_id = "${aws_instance.us8_test_data_instance.id}"
}

resource "aws_ebs_volume" "datavolume" {
    availability_zone = "${var.availability_zones}"
    type           = "${var.db_volume_type}"
    encrypted = "${var.kms_encryption_enable}"
    kms_key_id        = "${var.kms_key_id}"
    size = "${var.db_volume_size}"
    tags = {
    Name = "${var.db_volume_name}"
  }
}

resource "aws_volume_attachment" "ebs_db" {
  device_name = "${var.db_volume_devicename}"
  volume_id   = "${aws_ebs_volume.datavolume.id}"
  instance_id = "${aws_instance.us8_test_data_instance.id}"
}