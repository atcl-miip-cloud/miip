# S3 배포
- S3에 project name 으로 시작하는 버킷과 해당 버킷의 access log를 기록하는 버킷을 생성한다.

# How to launch
- 처음 실행시 기존 잔여 부분 있다면 삭제
```
rm -rf .terraform
rm -f *.tfstate*
```

- 실행
```
terraform init  -backend-config="../project.tfvars"
terraform plan  -var-file="../project.tfvars"
terraform apply -var-file="../project.tfvars" -auto-approve
```