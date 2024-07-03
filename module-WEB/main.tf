resource "aws_vpc" "VPC" {
  cidr_block = var.VPC-cidr
}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = var.sub1-cidr
  availability_zone       = var.sub1-availability_zone
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = var.sub2-cidr
  availability_zone       = var.sub2-availability_zone
  map_public_ip_on_launch = true
}


resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "WebSG" {
  vpc_id = aws_vpc.VPC.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    name = "web-sg"
  }
}

resource "aws_instance" "webser1" {
  ami                    = var.ami
  instance_type          = var.instance-type
  subnet_id              = aws_subnet.sub1.id
  vpc_security_group_ids = [aws_security_group.WebSG.id]
  user_data              = base64encode(file(var.userdata-1))
  tags = {name = var.webser1}
}

resource "aws_instance" "webser2" {
  ami                    = var.ami
  instance_type          = var.instance-type
  subnet_id              = aws_subnet.sub2.id
  vpc_security_group_ids = [aws_security_group.WebSG.id]
  user_data              = base64encode(file(var.userdata-2))
  tags = {name = var.webser2}
}

resource "aws_lb" "ALB" {
  name               = var.LB-name
  internal           = false
  load_balancer_type = var.LB-type
  security_groups    = [aws_security_group.WebSG.id]
  subnets            = [aws_subnet.sub1.id, aws_subnet.sub2.id]
  tags = {
    name = "web"
  }
}

resource "aws_lb_target_group" "TG" {
  name     = "my-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.VPC.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.TG.arn
  target_id        = aws_instance.webser1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.TG.arn
  target_id        = aws_instance.webser2.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG.arn
  }
}

output "load_balancer_dns" {
  value = aws_lb.ALB.dns_name
}