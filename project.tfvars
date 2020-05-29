project_name = "miip-d"                # 프로젝트명 : 주의! : 소문자, 숫자, - 만 사용 할것 (only lowercase alphanumeric characters and hyphens allowed)
profile      = "miip"                       # aws cli profile name - README.md 참조
bucket       = "miip.miip-d.tfstate"   # Terraform Backend용 Bucket , 네이밍 룰 : profile.project_name.tfstate 
region       = "ap-northeast-2"
