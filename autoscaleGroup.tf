# Create a Launch Configuration -----------------------------------------------
resource "aws_launch_template" "nginx_auto_scale" {
  name_prefix            = "nginx-auto-scale"
  image_id               = var.aws_ami
  instance_type          = lookup(var.instance_type, "instance")
  update_default_version = true
  iam_instance_profile {
    name = aws_iam_instance_profile.iam_instance_profile.name
   }
   
  vpc_security_group_ids = [aws_security_group.allow_filtered_traffic.id]

  user_data = base64encode(
    <<-EOF
    #!/bin/bash
    amazon-linux-extras install -y nginx1
    systemctl enable nginx --now
    EOF
  )
}

# Create a ASG ----------------------------------------------------------------
resource "aws_autoscaling_group" "auto_scale_group" {
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  vpc_zone_identifier = [aws_subnet.terraform_sub3.id, aws_subnet.terraform_sub4.id]
  target_group_arns = [aws_lb_target_group.alb_target.arn]
  launch_template {
    id      = aws_launch_template.nginx_auto_scale.id
    version = "$Latest"
  }
  tag {
    key = "Name"
    value = "auto-scaled-instances"
    propagate_at_launch = true
  }
}

# Create Auto Scale Policy ----------------------------------------------------

resource "aws_autoscaling_policy" "nginx_autoscale_policy" {
  name                   = "scale-by-one"
  scaling_adjustment     = 1
  adjustment_type        = lookup(var.auto_scale_policy_type, "policy_type")
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.auto_scale_group.name
}

# Attach Policy ---------------------------------------------------------------
resource "aws_autoscaling_attachment" "asg_attachment_lb" {
  autoscaling_group_name = aws_autoscaling_group.auto_scale_group.id
  lb_target_group_arn = aws_lb_target_group.alb_target.arn
}
