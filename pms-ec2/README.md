# EC2 Bastion 서버 생성
- Ubuntu 서버 1대
- Windows 2019 서버 1대
- Keypair는 

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