[![CircleCI](https://circleci.com/gh/miip/mvp-demo-aws.svg?style=svg&circle-token=18533a9c9451d057f17775bcebc6c3fb91675be9)](https://circleci.com/gh/miip/mvp-demo-aws)

# 개요
Cloud Platform MVP demo 환경을 위한 인프라 코드 저장소 입니다.

# 방안
- 디렉토리별 작업 단위가 이루어 지며 독립적으로 빌드/테스트가 이루어질 수 있어야 합니다.

# 주의 사항
- 절대로 Private Key 또는 Secret Access Key, Password는 커밋하지 마세요.
- Public Key, Access Key (public id), id 까지는 괜찮습니다. (가급적 지양)

# 요구 사항
## 실행 전 변수 체크
- `project.tfvars`에 있는 값을 최우선으로 적용합니다.
- project_name = "mvp-aws-adv"   프로젝트 명 으로 모든 네이밍의 기준이 됩니다.
- profile      = "skcc"                # aws cli profile 로 셋팅될 name으로 값입니다.
- bucket       = "skcc.mvp-aws-adv.tfstate"   # 네이밍 룰 : profile.project_name.tfstate 
- region       = "ap-northeast-2"

## EC2 Keypair
- 기본 `ec-default-ssh-key.pub` 를 사용, `프로젝트명-default` 로 AWS 콘솔에 등록 된다.
- 해당 Pub 키파일 내용을 직접 바꾸거나, AWS콘솔에서 키페어를 등록하고 각 variable 변수로 등록


## 환경 변수 프로젝트명
- CI에서 제공 셋팅 되는 환경 변수는 아래와 같습니다. 개인 테스트시에도 아래 환경 변수명으로 설정 해주세요.
- 프로젝트명
  - `CP_PROJECT_NAME`=skcc-aws-general
- 클라우드 크리덴셜 및 환경 변수
  - `AWS_ACCESS_KEY_ID`=
  - `AWS_SECRET_ACCESS_KEY`=

## Terraform : `project.tfvars` 값을 먼저 설정 필요
- 해당 파일은 tfvars 이지만 실제 `tfvars`용 변수와 `backend config`용 변수로 같이 씁니다.
- 기본 실행 순서
```
terraform init  -backend-config="../project.tfvars"
terraform plan  -var-file="../project.tfvars" -out tfplan.out
terraform apply tfplan.out
```

### project_name
- `소문자`, `숫자`, `-` 만 사용 가능 (`_`(underbar)쓰면 버킷명 만들때 에러남.)
- `project_name = "skcc-aws-general"`

### profile
- aws cli에서 쓰는 profile name 임. terraform에서 default로 기본 설정된 값을 쓰는 경우를 방지 하기 위해 다른 의도된 계정의 프로파일로 설정
- 예: `profile = "skcc"`

### region
- 자원을 만들 AWS 리전
- `region = "ap-northeast-2"`

### bucket
- tfstate를 저장할 버킷명
- 네이밍 룰 : `profile`.`project_name`.tfstate 
- `bucket = "mvp.skcc-aws-general.tfstate"`

## 실행 순서
### 1. 먼저 tf-backend를 생성

```
cd tf-backend

```

### 2. 각 서브 모듈을 필요 순서대로 실행

## aws profile 설정 법
```
$ aws configure --profile miip
AWS Access Key ID [****************aaaa]:
AWS Secret Access Key [****************aaaa]:
Default region name [ap-northeast-2]:
Default output format [json]:
```
### 사용법
- OSX, Linux Shell : `export AWS_DEFAULT_PROFILE=skcc`
- Windows Command : `set AWS_DEFAULT_PROFILE=skcc`
- Terraform
```
provider "aws" {
  version = "~> 2.0"
  region  = "ap-northeast-2"
  profile = "miip"
}
```

### 프로파일 생성
- 환경 변수에 AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION 가 정의 되어 있을 경우
`set_aws_configure.sh`를 실행하면 `miip` 프로파일로 설정해준다.
- Docker 실행시 profile 셋팅을 위해 만듦
