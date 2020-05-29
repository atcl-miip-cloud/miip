# 개요

- VPC 생성

# 생성 리소스
- VPC
- Subnet & Routing Tables
- NAT Gateway, VPN Gateway
- S3 Gateway Endpoint 
- EFS Interface Endpoint , SSM Interface Endpoint
- DB Subnet Group

# 사용법
``` bash
# 초기화 하고 할려면 불필요 파일을 먼저 삭제 한다.
rm -rf .terraform
rm -f *.tfstate*
```

``` bash
# profile 전환
export AWS_DEFAULT_PROFILE=miip

# Terraform 수행
terraform init  -backend-config="../project.tfvars"
terraform plan  -var-file="../project.tfvars" -var-file="../default-tags.tfvars"  -out tfplan.out
terraform apply tfplan.out
```
