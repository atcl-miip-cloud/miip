# aws eks list-clusters
export CP_PROJECT_NAME=$(grep -o '^[^#]*' ../project.tfvars | awk -F "=" '/project_name/{print $2}'| sed 's/[" ]//g')
export AWS_DEFAULT_REGION=$(grep -o '^[^#]*' ../project.tfvars | awk -F "=" '/region/{print $2}'| sed 's/[" ]//g')
export AWS_REGION=$AWS_DEFAULT_REGION
export AWS_DEFAULT_PROFILE=$(grep -o '^[^#]*' ../project.tfvars | awk -F "=" '/profile/{print $2}'| sed 's/[" ]//g')
export CLUSTER_NAME=${CP_PROJECT_NAME}-pms-cluster

AWS_AIC_VER=v1.1.7
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
VPC_ID=$(aws eks describe-cluster --name ${CLUSTER_NAME} --query cluster.resourcesVpcConfig.vpcId --output text)
ALB_POLICY=ALBIngressControllerIAMPolicy
export AWS_DEFAULT_REGION=${AWS_REGION}

# 2. IAM OIDC 공급자를 생성하여 클러스터와 연결
aws eks --region ${AWS_REGION} update-kubeconfig --name ${CLUSTER_NAME}
eksctl utils associate-iam-oidc-provider \
      --region ap-northeast-2 \
      --cluster $CLUSTER_NAME \
      --approve

# 3. ALB Ingress Pod에 대해 사용자를 대신하여 AWS API를 호출할 수 있도록 하는 ${ALB_POLICY} 라는 IAM 정책을 생성합니다.
curl -sSO https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/$AWS_AIC_VER/docs/examples/iam-policy.json
POLICY_ARN=$(aws iam create-policy --policy-name ${ALB_POLICY} --policy-document file://iam-policy.json --query Policy.Arn --output text)
# 위에서 나온 policy arn 설정 (선택, 에러날 경우 대비;;;)
POLICY_ARN=arn:aws:iam::${ACCOUNT_ID}:policy/${ALB_POLICY}

# kube-system 네임스페이스의 Kubernetes 서비스 계정(alb-ingress-controller), 클러스터 역할 및 ALB 수신 컨트롤러에 대한 클러스터 역할 바인딩
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/${AWS_AIC_VER}/docs/examples/rbac-role.yaml

# role을 생성하고, 앞에서 만든 ${ALB_POLICY}를 붙인다.
###########################
OIDC_PROVIDER=$(aws eks describe-cluster --name ${CLUSTER_NAME} --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")
SA_NAMESPACE=kube-system
SA_NAME=alb-ingress-controller
ALB_ROLE_NAME=${CLUSTER_NAME}-${SA_NAME}
read -r -d '' TRUST_RELATIONSHIP <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${ACCOUNT_ID}:oidc-provider/${OIDC_PROVIDER}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${OIDC_PROVIDER}:sub": "system:serviceaccount:${SA_NAMESPACE}:${SA_NAME}"
        }
      }
    }
  ]
}
EOF
aws iam create-role --role-name ${ALB_ROLE_NAME} --assume-role-policy-document "${TRUST_RELATIONSHIP}" --description "EKS Service Account Role"
POLICY_ARN=arn:aws:iam::${ACCOUNT_ID}:policy/${ALB_POLICY}
aws iam attach-role-policy --role-name ${ALB_ROLE_NAME} --policy-arn=${POLICY_ARN}
#######################################

# K8s serviceaccount 에 앞에서 만든 role을 명시한다(annotate)
kubectl annotate serviceaccount -n kube-system ${SA_NAME} \
        eks.amazonaws.com/role-arn=arn:aws:iam::${ACCOUNT_ID}:role/${ALB_ROLE_NAME} --overwrite

# Ingress Controller 배포
curl -sLO https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/${AWS_AIC_VER}/docs/examples/alb-ingress-controller.yaml
SPACES=$(printf '%.0s ' {1..12})
# Mac 환경에서는 gnu-sed(gsed)를 사용해야함
sed -i "/- --ingress-class=alb/a\\
${SPACES}- --cluster-name=${CLUSTER_NAME}\\
${SPACES}- --aws-vpc-id=${VPC_ID}\\
${SPACES}- --aws-region=${AWS_REGION}" alb-ingress-controller.yaml
#한줄로 하면
#sed -i "/- --ingress-class=alb/a${SPACES}- --cluster-name=${CLUSTER_NAME}\n${SPACES}- --aws-vpc-id=${VPC_ID}\n${SPACES}- --aws-region=${AWS_REGION}" alb-ingress-controller.yaml
kubectl apply -f alb-ingress-controller.yaml

# Test
URL_PREFIX="https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/${AWS_AIC_VER}/docs/examples"
kubectl apply -f ${URL_PREFIX}/2048/2048-namespace.yaml
kubectl apply -f ${URL_PREFIX}/2048/2048-deployment.yaml
kubectl apply -f ${URL_PREFIX}/2048/2048-service.yaml
kubectl apply -f ${URL_PREFIX}/2048/2048-ingress.yaml
#(선택) ALB 주소 확인 및 접속
kubectl get ingress -n 2048-game

# # delete Test (역순)

kubectl delete -f ${URL_PREFIX}/2048/2048-ingress.yaml
kubectl delete -f ${URL_PREFIX}/2048/2048-service.yaml
kubectl delete -f ${URL_PREFIX}/2048/2048-deployment.yaml
kubectl delete -f ${URL_PREFIX}/2048/2048-namespace.yaml