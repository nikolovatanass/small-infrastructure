# Creating IAM role -----------------------------------------------------------
resource "aws_iam_role" "ssm_nginx_role" {
  name = "ssm-nginx-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Attaching instance policy to role -------------------------------------------
resource "aws_iam_role_policy_attachment" "ssm_mgmt_attachment" {
  role       = aws_iam_role.ssm_nginx_role.id
  policy_arn = var.policy_ssm
}

# Attaching Cloud Watch policy to role ----------------------------------------
resource "aws_iam_role_policy_attachment" "cloud_watch_attachment" {
  role       = aws_iam_role.ssm_nginx_role.id
  policy_arn = var.policy_cwa
}

# Creating instance profile with the role -------------------------------------
resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "instance-profile"
  role = aws_iam_role.ssm_nginx_role.name
}
