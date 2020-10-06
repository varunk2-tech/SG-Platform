resource "aws_instance" "us8_test_dmz_instance" {
  ami = "${var.ami_id}"
  instance_type = "${var.instance_types}"
  availability_zone = "${var.availability-zones}"
  subnet_id = "${var.dmz_subnet}"
  disable_api_termination = "${var.terminate}"
  security_groups = ["${var.dmz_security_group}"]
  user_data = "${file("/root/terraform/dmz01/dmz-puppet.sh")}"
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
    delete_on_termination = "${var.terminate}"
  }
}

#resource "aws_eip" "example" {
# count1 = "${var.count1}"
#}

resource "aws_eip_association" "eip_assoc" {
   instance_id   = "${aws_instance.us8_test_dmz_instance.id}"
   allocation_id = "${var.eip}"
}

resource "aws_ebs_volume" "swapvolume" {
    availability_zone = "${var.availability-zones}"
    type           = "${var.swap_volume_type}"
    encrypted = "${var.kms_encryption_enable}" 
    kms_key_id        = "${var.kms_key_id}"
    size = "${var.swap_volume_size}"
    tags = {
    Name = "${var.swap_volume_name}"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "${var.swap_volume_devicename}"
  volume_id   = "${aws_ebs_volume.swapvolume.id}"
  instance_id = "${aws_instance.us8_test_dmz_instance.id}"
}