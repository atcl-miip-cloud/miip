# 개요

- Terraform의 상태 정보를 원격에 저장하기 위한 Remote Backend를 위한 S3와 DynamoDB Table을 생성 한다.
- 공통 환경 변수는 상위 디렉토리의 `project.tfvars` 에서 가져 온다.
- backend 자체의 tfstate 따로 원격 저장 되지 않으므로 주의 한다.


# 생성 리소스
- tfstate 파일 저장용도 S3 버킷
- 상기 버킷 Access Log 저장용 S3 버킷
- ec2 default keypair 등록

# 주의 사항
- 프로젝트 시작시 초기 1회만 수행 

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
