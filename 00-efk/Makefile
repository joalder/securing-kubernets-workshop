install-efk:
	@kubectl apply -f 00-elastic-crds.yaml
	@kubectl apply -f 01-elastic-cluster.yaml
	@kubectl apply -f 02-kibana.yaml
	@kubectl apply -f 03-fluentd.yaml

kibana-password:
	@kubectl -n efk get secret azathoth-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode
