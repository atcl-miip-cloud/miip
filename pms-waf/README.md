# How to launch

# How to launch
- 처음 실행시 기존 잔여 부분 있다면 삭제
```
rm -rf .terraform
rm -f *.tfstate*
```

- 실행
```
# export PROJECT_NAME="skcc-aws-general"
# export KUBECONFIG="kubeconfig_${PROJECT_NAME}"
terraform init  -backend-config="../project.tfvars"
terraform plan  -var-file="../project.tfvars" -out tfplan.out
terraform apply tfplan.out
```