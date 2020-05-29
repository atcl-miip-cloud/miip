# Elasticsearch at vpc env.

# How to launch
- Image
```
 image: elastic/elasticsearch:6.8.6 (elasticsearch)
 image: elastic/kibana:6.8.6 (kibana)
 image: fluent/fluentd-kubernetes-daemonset:v1.4.2-debian-elasticsearch-1.1 (fluentd)
```

- 실행
```
git clone https://github.com/miip/mvp-demo-aws.git (private)
git user ID : 입력
git user PW : 입력

cd mvp-demo-aws/miip-logging

kubectl create ns logging

kubectl create -f elasticsearch.yaml
kubectl create -f kibana.yaml
kubectl create -f fluentd.yaml

kubectl get svc --all-namespaces (서비스 확인)
```

- 접속방법
```
kibana-svc EXTERNAL-IP:5601로 접속 (kibana가 만들어지는데 시간이 좀 걸리기때문에 5분 정도 대기했다가 접속 권유)
```
- Kibana web 화면에서 로그 보는법
```
왼쪽 항목에서 Discover 클릭
create index pattern에서 logstash-* 입력 후 next step
Time Filter field name에서 @timestamp 선택후 create index pattern
Discover 클릭하여 확인
```
