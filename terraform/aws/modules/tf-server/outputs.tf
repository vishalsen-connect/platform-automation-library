output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ec2_instance.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ec2_instance.public_ip
}

output "instance_keypair" {
  description = "Keypair of the EC2 instance"
  value       = local_file.private_key.filename
}

output "bucket_name" {
    value = aws_s3_bucket.my_bucket.id
}

output "bucket_folder_name" {
    value = aws_s3_object.prod_folder.id
}
