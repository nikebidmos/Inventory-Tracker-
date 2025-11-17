# security group for ALB (allow inbound 80 from internet)
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow http from internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# security group for app (EC2) — allow from ALB only, and allow outbound to RDS
resource "aws_security_group" "app_sg" {
  name = "app-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description = "Allow traffic from ALB to app"
  }

  # allow SSH from GitHub Actions runner IPs? For simplicity allow SSH from 0.0.0.0/0 — restrict in real life
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH (restrict in production)"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# security group for RDS — allow only from app_sg
resource "aws_security_group" "rds_sg" {
  name = "rds-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [aws_security_group.app_sg.id]
    description = "Allow Postgres from app only"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
