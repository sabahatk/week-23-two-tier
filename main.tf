/************VPC********/
resource "aws_vpc" "TF_VPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Terraform VPC"
  }
}

/************Subnets********/
resource "aws_subnet" "publicA" {
  vpc_id     = aws_vpc.TF_VPC.id
  cidr_block = "10.0.1.0/24"
  #assign_ipv6_address_on_creation = true
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet A"
  }
}

resource "aws_subnet" "publicB" {
  vpc_id     = aws_vpc.TF_VPC.id
  cidr_block = "10.0.2.0/24"
  #assign_ipv6_address_on_creation = true
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet B"
  }
}

resource "aws_subnet" "privateA" {
  vpc_id     = aws_vpc.TF_VPC.id
  cidr_block = "10.0.3.0/24"
  #assign_ipv6_address_on_creation = true

  tags = {
    Name = "Private Subnet A"
  }
}

resource "aws_subnet" "privateB" {
  vpc_id     = aws_vpc.TF_VPC.id
  cidr_block = "10.0.4.0/24"
  #assign_ipv6_address_on_creation = true

  tags = {
    Name = "Private Subnet B"
  }
}

/**************Route Table***********/
resource "aws_route_table" "TF_RT" {
  vpc_id = aws_vpc.TF_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_gw.id
  }


  tags = {
    Name = "Terraform Route Table"
  }
}


/********* IGW ********/
resource "aws_internet_gateway" "tf_gw" {
  vpc_id = aws_vpc.TF_VPC.id

  tags = {
    Name = "Terraform IGW"
  }
}

/******** Routes **********

resource "aws_route_table_association" "IGW_route" {
  cidr_block     = "0.0.0.0/0"
  gateway_id     = aws_internet_gateway.tf_gw.id
  route_table_id = aws_route_table.TF_RT.id
}
*/

resource "aws_route_table_association" "publicA_route" {
  subnet_id      = aws_subnet.publicA.id
  route_table_id = aws_route_table.TF_RT.id
}

resource "aws_route_table_association" "publicB_route" {
  subnet_id      = aws_subnet.publicB.id
  route_table_id = aws_route_table.TF_RT.id
}



/*********** Instances *********/
resource "aws_instance" "apacheA" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_name
  vpc_security_group_ids = [aws_security_group.TF_SG.id]
  subnet_id              = aws_subnet.publicA.id

  tags = {
    Name = var.instance_name_a
  }
  user_data = file(var.ud_filepath)
}

resource "aws_instance" "apacheB" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_name
  vpc_security_group_ids = [aws_security_group.TF_SG.id]
  subnet_id              = aws_subnet.publicB.id

  tags = {
    Name = var.instance_name_b
  }
  user_data = file(var.ud_filepath)
}

/***************** Security Groups *****************/
#Add security group to allow port 22 and 80 traffic
resource "aws_security_group" "TF_SG" {
  name        = var.sg_name
  description = var.sg_name
  vpc_id      = aws_vpc.TF_VPC.id

  ingress {
    description = var.http_desc
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = var.protocol_tcp
    cidr_blocks = var.cidr_block
  }

  ingress {
    description = var.ssh_desc
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.protocol_tcp
    cidr_blocks = var.cidr_block
  }

  egress {
    from_port   = var.outbound_port
    to_port     = var.outbound_port
    protocol    = var.protocol_outbound
    cidr_blocks = var.cidr_block
  }

  tags = {
    Name = var.sg_tag
  }
}

/********** RDS Instance *********/
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "RDS"
  password             = "RDSPassword"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
}

/********* Subnet Group *********/
resource "aws_db_subnet_group" "subnet_group" {
  name       = "main"
  subnet_ids = [aws_subnet.privateA.id, aws_subnet.privateB.id]

  tags = {
    Name = "My DB subnet group"
  }
}