# Cloudwatch configuaration ---------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "autoscale_alarm" {
  alarm_name                = lookup(var.cloudwatch_alarm, "alarm_name")
  comparison_operator       = lookup(var.cloudwatch_alarm, "comparison")
  evaluation_periods        = 1
  metric_name               = lookup(var.cloudwatch_alarm, "metric_name")
  namespace                 = lookup(var.cloudwatch_alarm, "name_space")
  period                    = 60
  statistic                 = lookup(var.cloudwatch_alarm, "statistic")
  threshold                 = 80
  alarm_description         = lookup(var.cloudwatch_alarm, "description")
  alarm_actions = [aws_autoscaling_policy.nginx_autoscale_policy.arn]
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.auto_scale_group.name

  }
}