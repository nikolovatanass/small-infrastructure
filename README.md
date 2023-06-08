# small-infrastructure
Small AWS infrastructure created with Terraform

This configuration contains a vps with 4 subnets (2 public and 2 private)

The public networks are connected to the IGW.

The private networks are connected to the public networks via NAT

There is a load balancer configured to accept HTTP traffic and forward it to a autoscaling group


![exam drawio](https://github.com/nikolovatanass/small-infrastructure/assets/131749298/0c8e27da-04cc-4c5e-adf6-9bd426521af8)
