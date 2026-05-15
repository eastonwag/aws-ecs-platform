AWS ECS Platform




What it is:
A cloud-native job application tracker built to demonstrate production-pattern AWS infrastructure. The project deploys a containerized Node.js REST API backed by PostgreSQL, running on ECS Fargate behind an Application Load Balancer, with fully automated deployments via GitHub Actions.



Architecture:
Internet → Application Load Balancer (port 80)
         → ECS Fargate (Node.js API, port 3000)
         → RDS PostgreSQL (port 5432)



Tech Stack:
- AWS — ECS Fargate, RDS PostgreSQL, ALB, VPC, ECR, SSM, CloudWatch
- Terraform — all infrastructure defined as code across 6 modules
- Docker — containerized Node.js API built for linux/amd64
- GitHub Actions — CI/CD pipeline with OIDC authentication



Design Decisions:
- Public subnets for ECS instead of private — A NAT Gateway costs roughly $30/month. For a learning project, public subnets with strict security group rules provide acceptable security at zero extra cost. In production I would use private subnets with a NAT Gateway.

- SSM Parameter Store for secrets — Database credentials are stored in SSM and injected into the container at runtime. Nothing sensitive is hardcoded or stored in the repository.

- OIDC for GitHub Actions — GitHub authenticates to AWS using short lived tokens instead of static IAM keys. This eliminates the risk of long lived credentials being exposed in the repository.



API Endpoints:
- GET  /health  — health check
- GET  /jobs    — retrieve all job applications
- POST /jobs    — create a job application
- Body: { "title": "string", "company": "string", "status": "string" }



How To Deploy:
1. Configure AWS CLI with valid credentials
2. Store database password in SSM: /myapp/db/password
3. Run terraform init && terraform apply from the terraform directory
4. Push a Docker image to ECR
5. GitHub Actions handles all subsequent deployments on push to main



What I Would Add In Production:
- Private subnets with NAT Gateway for ECS
- HTTPS with ACM certificate and Route53 custom domain
- Auto scaling policy based on CPU and memory
- Database migration strategy instead of manual table creation
- Secrets Manager instead of SSM for automatic rotation
- Multi-AZ RDS for high availability