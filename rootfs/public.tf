

resource "aws_security_group" "cosmos-NSOT_region1" {
    provider = "aws.ohio"
    name = "cosmos-vrouter-sg"
    description = "Allow incoming traffic"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["10.0.0.0/8"]
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["100.64.0.0/10"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8990
        to_port = 8990
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 655
        to_port = 655
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress { # allow all outbound
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }


    vpc_id = "${aws_vpc.cosmos-vrouter-corerouter-region1-vpc.id}"

    tags {
        Name = "cosmos-vrouter-SG"
        environment = "cosmos-test"
    }
}
resource "aws_key_pair" "cosmos-admin" {
  provider = "aws.ohio"
  key_name = "cosmos-admin4"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_instance" "cosmos-NSOT" {
    provider = "aws.ohio"
    ami = "${var.ami_region1}"
    availability_zone = "us-east-2a"
    instance_type = "t2.small"
    key_name = "${aws_key_pair.cosmos-admin.key_name}"
    vpc_security_group_ids = ["${aws_security_group.cosmos-NSOT_region1.id}"]
    subnet_id = "${aws_subnet.us-east-2a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false
    tags {
        Name = "cosmos-NSOT-TF"
    }

    provisioner "file" {
    source      = "generate-nsot-configs.sh"
    destination = "/tmp/generate-nsot-configs.sh"
   }
    provisioner "file" {
        source = "input.txt"
        destination = "input.txt"
    }

    provisioner "remote-exec" {
        inline = [
           "echo Y | sudo apt-get update",
           "echo Y | sudo apt-get -y install build-essential python-dev libffi-dev libssl-dev",
           "echo Y | sudo apt-get --yes install python-pip git",
           "sudo wget --quiet https://pypi.python.org/packages/40/9b/0bc869f290b8f49a99b8d97927f57126a5d1befcf8bac92c60dc855f2523/mysqlclient-1.3.10.tar.gz",
           "sudo tar -xvzf mysqlclient-1.3.10.tar.gz",
           "echo Y | sudo apt install libmysqlclient-dev",
           "cd mysqlclient-1.3.10/",
           "sudo python setup.py build",
           "sudo python setup.py install",
           "echo Y | sudo pip install nsot",
           "echo Y | sudo pip install pynsot",
           "cd ~/",
           "sudo nsot-server init",
           "chmod +x /tmp/generate-nsot-configs.sh",
           "sudo /tmp/generate-nsot-configs.sh ${var.RDS_NAME} ${var.RDS_USER} ${var.RDS_PASS} ${var.RDS_HOST} ${var.RDS_PORT}",
           "cat input.txt | nohup sudo nsot-server start &",
           "sleep 1"
      ]
  }
  connection {
      user = "${var.INSTANCE_USERNAME}"
      private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
    }

  }

 