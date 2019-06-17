install-efk:
	@kubectl apply -f 00-elastic-crds.yaml
	@kubectl apply -f 01-elastic-cluster.yaml
	@kubectl apply -f 02-kibana.yaml
	@kubectl apply -f 03-fluentbit-rbac.yaml
	@kubectl apply -f 04-fluent-bit-configmap.yaml
	@kubectl apply -f 05-fluent-bit-ds.yaml

reconfigure-fluentd:
	@kubectl apply -f 04-fluent-bit-configmap.yaml
	@kubectl -n efk delete pods -l k8s-app=fluent-bit-logging

kibana-password:
	@kubectl -n efk get secret azathoth-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode
