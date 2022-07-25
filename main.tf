provider "aws" {
  region = "eu-west-3"
}

variable vpc_cidr {}
variable subnet_cidr {}
variable availzone {}
variable env_p {}
variable my_ip {}
variable instance_type {}
variable public_key {}


  resource "aws_vpc" "webapp-vpc"{
    cidr_block = var.vpc_cidr
    tags = {
      Name: "${var.env_p}-vpc"
    }
  }
  
  resource "aws_subnet" "webapp-subnet-1" {
    vpc_id = aws_vpc.webapp-vpc.id
    cidr_block = var.subnet_cidr
    availability_zone = var.availzone
    tags = {
      Name: "${var.env_p}-sub"
    }
  }
  
  resource "aws_internet_gateway" "webapp-igw"{
    vpc_id = aws_vpc.webapp-vpc.id
    tags = {
    	 	Name: "${var.env_p}-igw"
    	 }
  
  }

  resource "aws_route_table" "webapp-route-table" {
    vpc_id = aws_vpc.webapp-vpc.id
    route {
    	cidr_block = "0.0.0.0/0"
    	gateway_id = aws_internet_gateway.webapp-igw.id
    	 }
    	 tags = {
    	 	Name: "${var.env_p}-route-table"
    	 }
    } 
    
   resource "aws_route_table_association" "a-rtb-subnet" {
     subnet_id = aws_subnet.webapp-subnet-1.id
     route_table_id = aws_route_table.webapp-route-table.id
   
   }
   
   
   resource "aws_security_group" "webapp_sg"{
     name = "webapp_sg"
     vpc_id = aws_vpc.webapp-vpc.id
     
     ingress {
	from_port  = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = [var.my_ip]     
     
     }
      ingress {
	from_port  = 8080
	to_port = 8080
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]     
     
     }
     
     egress {
        from_port  = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]   
        prefix_list_ids = []
    }
    tags = {
    	 	Name: "${var.env_p}-sg"
    	 }
}

  data "aws_ami" "latest_alm" {
  most_recent = true
  owners = ["amazon"]
  filter {
  	name = "name"
  	values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
  }
  
  output "aws_ami"{
   value = data.aws_ami.latest_alm.id
  }
  
  
      resource "aws_key_pair" "ssh-key"{
    key_name = "server-key"
    public_key = "file(var.public_key)"
     
    }
    resource "aws_instance" "webapp-server" {
    ami = data.aws_ami.latest_alm.id
    instance_type = var.instance_type
    subnet_id = aws_subnet.webapp-subnet-1.id
    vpc_security_group_ids = [aws_security_group.webapp_sg.id]
    availability_zone = var.availzone
    associate_public_ip_address = true
    key_name = aws_key_pair.ssh-key.key_name
    
    user_data = file("entry-script.sh")
        tags = {
    	 	Name: "${var.env_p}-sg"
    	 }
    }
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

