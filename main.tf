provider "aws" {
  region     = "eu-west-2"
  shared_credentials_file = "c:/Users/nickr/.aws/credentials"
  profile = "TechSNIPS"
}
# Create our EC2 Instance
resource "aws_instance" "dev" {
  ami                         = "${var.ami}"
  instance_type               = "${var.aws_instance_type}"
  key_name                    = "${aws_key_pair.admin_key.key_name}"
  security_groups             = ["${aws_security_group.web_server.name}"]
  associate_public_ip_address = true

  tags {
    Name = "Ubuntu Pineapple Web Server"
  }

# This is needed for the provisioner to connect
connection {
    type         = "ssh"
    user         = "ubuntu"
    private_key  = "${file("~/.ssh/id_rsa")}"
     }
#Remote-Exec Inline will run one command after the other
provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install libapache2-mod-wsgi -y",
      "sudo apt-get install python3",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install python3-pip -y",
      "sudo apt-get install apache2 -y",
      "pip3 install flask",
      "sudo a2enmod wsgi",
      "sudo systemctl enable apache2",
      "sudo systemctl start apache2",
      "sudo chmod 777 /var/www/html/index.html"
   ]
}
}
# This will output our ip address
output "public_ip" {
  value = "${aws_instance.dev.public_ip}"
}