import boto3

region = 'eu-west-1'


def lambda_handler(event, context):
    instance_list = []
    client = boto3.client('autoscaling')
    response = client.describe_auto_scaling_groups(AutoScalingGroupNames=['terraform-20230608075321715400000005'])
    respo = response['AutoScalingGroups']
    print(respo)
    for i in respo:
        b = i['Instances']
        for c in b:
            f = c['InstanceId']
            instance_list.append(f)
    
    the_response = client.suspend_processes(
    AutoScalingGroupName='terraform-20230608075321715400000005',
    ScalingProcesses=['AlarmNotification','Launch', 'Terminate', 'AddToLoadBalancer', 'AZRebalance', 'HealthCheck', 'ScheduledActions', 'InstanceRefresh', 'ReplaceUnhealthy'])
    
    ec2 = boto3.client('ec2', region_name = 'eu-west-1')
    for id in instance_list:
        ec2.stop_instances(InstanceIds=[id])
    
