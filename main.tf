provider "aws" {
  region = "us-west-2"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "node_app_sg" {
  name_prefix = "node_app_sg_"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "node_app_sg"
  }
}

resource "aws_instance" "node_app" {
  ami           = "ami-0abcdef1234567890" # Amazon Linux 2 AMI ID (Bölgenize göre değiştirin)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.node_app_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nodejs npm git nginx
              npm install -g pm2
              cd /home/ec2-user
              git clone https://github.com/username/my-node-app.git
              cd my-node-app
              npm install
              pm2 start app.js
              
              # Configure Nginx
              cat > /etc/nginx/conf.d/my-node-app.conf <<EOL
              server {
                  listen 80;
                  server_name sumeyyedev.site;

                  location / {
                      proxy_pass http://localhost:3000;
                      proxy_http_version 1.1;
                      proxy_set_header Upgrade $http_upgrade;
                      proxy_set_header Connection 'upgrade';
                      proxy_set_header Host $host;
                      proxy_cache_bypass $http_upgrade;
                  }
              }
              EOL

              service nginx restart
              EOF

  tags = {
    Name = "Node.js-Server"
  }
}

output "instance_ip" {
  value = aws_instance.node_app.public_ip
}