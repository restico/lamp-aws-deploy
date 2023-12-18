**DevOps Skills Test Project Overview**

[![Building Infrastructure](https://github.com/restico/lamp-aws-deploy/actions/workflows/deploy.yml/badge.svg)](https://github.com/restico/lamp-aws-deploy/actions/workflows/deploy.yml)

**Project Site:** [GitHub](https://github.com/Practical-DevOps/app-for-devops)

**Description:**
The project is a web application built with PHP and the Laravel framework for the backend, NodeJS for the frontend, and MySQL as the database. The entire CI/CD pipeline is organized using GitHub Actions, and the deployment involves setting up AWS infrastructure using Terraform (Infrastructure as Code) and configuring the web servers (EC2 instances) with Ansible.

**CI/CD Stages:**
1. **Git Checkout:**
   - This stage involves checking out the source code from the GitHub repository.

2. **Setting up AWS Infrastructure with Terraform (IaC):**
   - Infrastructure as Code (IaC) is implemented using Terraform to set up AWS resources.
   - AWS Resources created:
     - VPC with two subnets
     - Two security groups for servers and the database server
     - Two key pairs generated for SSH connection
     - Load Balancer used to distribute traffic between instances
     - MySQL configured as RDS server

3. **Setting up Web Servers (EC2 Instances) with Ansible:**
   - Ansible is used for configuring the web servers (EC2 instances) after the infrastructure is set up.
   - Configuration tasks may include installing dependencies, deploying the application code, and any other necessary server configurations.

**AWS Resources Overview:**
- **VPC:**
  - Virtual Private Cloud (VPC) is set up with two subnets.
- **Security Groups:**
  - Two security groups are created - one for servers and another for the database server.
- **Key Pairs:**
  - Two key pairs are generated for SSH connection to instances.
- **Load Balancer:**
  - A Load Balancer is used to distribute traffic between EC2 instances, ensuring high availability and fault tolerance.
- **MySQL as RDS Server:**
  - MySQL is implemented as a Relational Database Service (RDS) server, providing a managed database solution.

**Notes:**
- The CI/CD pipeline ensures a streamlined and automated process from code commit to deployment.
- The use of Terraform for infrastructure provisioning and Ansible for configuration management aligns with DevOps practices.
- AWS resources are structured for scalability, security, and high availability.

**Improvement Suggestions:**
- Consider incorporating automated testing stages in the CI/CD pipeline for enhanced code quality.
- Implement monitoring and logging solutions to track application performance and troubleshoot issues efficiently.
- Move instances to Auto Scaling group to automate creation and termination of additional instances used during traffic peaks.
- Evaluate the use of a configuration management tool like Ansible for application deployment alongside server configuration.
- Regularly update dependencies and review security best practices for AWS resources.