variable "vpc" {
    default = "172.16.0.0/16"
  
}
variable "subnet_type" {
  default = {
    public  = "public"
    private = "private"
  }
}

variable "cidr_ranges" {
  default = {
    public1  = "172.16.1.0/24"
    public2  = "172.16.3.0/24"
    private1 = "172.16.4.0/24"
    private2 = "172.16.5.0/24"
  }
}

variable "instance_type" {
    default = {
        instance = "t2.micro"
    }
  
}

variable "auto_scale_policy_type" {
    default = {
        policy_type = "ChangeInCapacity"
    }
  
}

variable "cloudwatch_alarm" {
    default = {
        alarm_name = "autoscale-alarm"
        comparison = "GreaterThanOrEqualToThreshold"
        metric_name = "CPUUtilization"
        name_space = "AWS/EC2"
        description = "This metric monitors ec2 cpu utilization"
        statistic = "Average"
    }
  
}

variable "policy_ssm" {
  default = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

variable "policy_cwa" {
  default = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

variable "aws_ami" {
    default = "ami-0e23c576dacf2e3df"
  
}
data "aws_availability_zones" "available" {
  state = "available"
}

