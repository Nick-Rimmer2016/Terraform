resource "aws_security_group" "web_server" {
  name = "web_server"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["xxx.xxx.xxx.xxx/32"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["xxx.xxx.xxx.xxx/32"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Deploy ssh key for instance access - Use Puttygen
resource "aws_key_pair" "admin_key" {
  key_name = "web_server" 
  public_key = "ssh-rsa AAAAB3NzaC1y etc etc"
}