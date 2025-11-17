
resource "aws_iam_role" "ec2_role" {
  name = "inventory-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name = var.key_pair_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash
              apt-get update || yum update -y
              # install docker
              if command -v apt-get >/dev/null 2>&1; then
                apt-get install -y docker.io
                systemctl enable --now docker
              else
                yum install -y docker
                systemctl enable --now docker
              fi
              # install docker-compose (simple method)
              curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              # create app directory and a minimal docker-compose that will be updated by CI via SSH
              mkdir -p /home/ubuntu/app
              chown -R ubuntu:ubuntu /home/ubuntu/app
              EOF

  tags = {
    Name = "inventory-app-ec2"
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "inventory-ec2-profile"
  role = aws_iam_role.ec2_role.name
}
