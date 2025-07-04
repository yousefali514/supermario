Deploying it on EKS using GitLab CI/CD and Terraform! 
In my latest project, I set up an automated GitLab pipeline running on an EC2 GitLab Runner, with two stages:
 Stage 1: Build the Kingdom (Infrastructure)
Using Terraform, I provisioned an EKS cluster across two AWS Availability Zones, each with:
 Two private subnets for node groups
 Two public subnets for an ALB & NAT Gateway
 IAM roles for EKS to manage permissions securely
 S3 & DynamoDB for Terraform state management
 Stage 2: Deploy the Game (Super Mario on EKS!)
Once the infrastructure was up, the pipeline deployed Super Mario onto the EKS cluster, making sure everything was ready for some classic gaming action.
