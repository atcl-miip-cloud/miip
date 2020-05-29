# 개요

- RDS maria db ha 생성

# 생성 리소스
- RDS
- Security Group

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
terraform init
terraform plan  -var-file="../project.tfvars" -var-file="../default-tags.tfvars"  -out tfplan.out
terraform apply tfplan.out
```
