#!/usr/bin/env bash

# AWS_DEFAULT_PROFILE의 CREDENTIAL이 재설정 됩니다. 실행시 주의 하세요. Docker 내부 사용 목적 파일입니다.

if [[ -z $AWS_ACCESS_KEY_ID || -z $AWS_SECRET_ACCESS_KEY ]]; then
  echo 'Should be defined : AWS_ACCESS_KEY_ID , AWS_SECRET_ACCESS_KEY'
  exit 1
fi

if [[ -z $CP_PROJECT_NAME ]]; then
  export CP_PROJECT_NAME=$(grep -o '^[^#]*' ../project.tfvars | awk -F "=" '/project_name/{print $2}'| sed 's/[" ]//g')
  echo "Set CP_PROJECT_NAME = $CP_PROJECT_NAME"
fi

if [[ -z $AWS_DEFAULT_REGION ]]; then
  export AWS_DEFAULT_REGION=$(grep -o '^[^#]*' ../project.tfvars | awk -F "=" '/region/{print $2}'| sed 's/[" ]//g')
fi
export AWS_REGION=$AWS_DEFAULT_REGION
echo "Set AWS_REGION = $AWS_REGION"


if [[ -z $AWS_DEFAULT_PROFILE ]]; then
  AWS_DEFAULT_PROFILE=$(grep -o '^[^#]*' ../project.tfvars | awk -F "=" '/profile/{print $2}'| sed 's/[" ]//g')
fi
aws configure set profile.${AWS_DEFAULT_PROFILE}.aws_access_key_id ${AWS_ACCESS_KEY_ID}
aws configure set profile.${AWS_DEFAULT_PROFILE}.aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
aws configure set profile.${AWS_DEFAULT_PROFILE}.region ${AWS_REGION}
aws configure set profile.${AWS_DEFAULT_PROFILE}.output json

export AWS_DEFAULT_PROFILE