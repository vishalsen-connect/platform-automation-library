# Create a S3 bucket for tf-statefile
resource "aws_s3_bucket" "my_bucket" {
    bucket = "${var.project_name}-terraform"
}

# Enable S3 versioning
resource "aws_s3_bucket_versioning" "versioning_my_bucket" {
  bucket = aws_s3_bucket.my_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create prod folder for prod-tf-state file
resource "aws_s3_object" "prod_folder" {
bucket = aws_s3_bucket.my_bucket.id
key    = "prod/"
acl    = "private"
}


# Create an IAM role for the EC2 instance
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-terraform-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the AdministratorAccess policy to the IAM role
resource "aws_iam_role_policy_attachment" "ec2_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.ec2_role.name
}

# Attach role to an intance profile
resource "aws_iam_instance_profile" "ec2_profile" {
    name = "${var.project_name}-ec2_profile"
    role = aws_iam_role.ec2_role.name
  
}

# Use RSA algorithm for private key
resource "tls_private_key" "private_key" {
    algorithm   =  "RSA"
    rsa_bits    =  4096
}

# Create ssh key pair
resource "local_file" "private_key" {
    content         =  tls_private_key.private_key.private_key_pem
    filename        =  "${var.project_name}-terraform.pem"
    file_permission =  0400
}

# Add keypair  
resource "aws_key_pair" "deploy_key" {
  key_name   = "${var.project_name}-terraform"
  public_key = tls_private_key.private_key.public_key_openssh
}


# Use default vpc
data "aws_vpc" "default" {
  default = true
}

# create a security group
resource "aws_security_group" "terraform-sg" {
  name_prefix = "${var.project_name}-terraform-sg"
  vpc_id      = data.aws_vpc.default.id
 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "office"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-terraform-sg"
    Environment = "prod"
  }
}

# Launch an EC2 instance with the IAM role
resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id 
  instance_type = "t2.micro"
  user_data = "${file("init.sh")}"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name      = aws_key_pair.deploy_key.key_name
  vpc_security_group_ids = [aws_security_group.terraform-sg.id]

  tags = {
    Name        = "${var.project_name}-terraform-server"
    Environment = "prod"
  }
}
