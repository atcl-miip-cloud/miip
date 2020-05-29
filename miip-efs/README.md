
# How to launch
- 처음 실행시 기존 잔여 부분 있다면 삭제
```
rm -rf .terraform
rm -f *.tfstate*
```

- 실행 방법
```
terraform init  -backend-config="../project.tfvars"
terraform plan  -var-file="../project.tfvars" -var-file="../default-tags.tfvars"  -out tfplan.out
terraform apply tfplan.out
```