## Description

Deploy Prometheus & Grafana using Ansible (Using shell command)

실행 방법 : ansible-playbook -i inventory deploy_telemetry.yaml

## 설치 후 "kubectl get svc -n monitoring" 후 grafana의 External IP로 접속
## id / password는 별도로 문의

## Requirements

- helm3
