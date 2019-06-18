NAMESPACE=efk

config-fluentd:
	@kubectl -n $(NAMESPACE) create configmap fluentd-config --from-file=fluentd-etc-confd -o yaml --dry-run > 03-fluentd-configmap.yaml

install-efk: config-fluentd
	@kubectl apply -f 00-elastic-crds.yaml
	@kubectl apply -f 01-elastic-cluster.yaml
	@kubectl apply -f 02-kibana.yaml
	@kubectl apply -f 03-fluentd-configmap.yaml
	@kubectl apply -f 04-fluentd.yaml

kibana-password:
	@kubectl -n efk get secret azathoth-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode

reconfigure-fluentd:
	@kubectl -n $(NAMESPACE) create configmap fluentd-config --from-file=fluentd-etc-confd -o yaml --dry-run > 03-fluentd-configmap.yaml
	@kubectl apply -f 03-fluentd-configmap.yaml
	@kubectl apply -f 04-fluentd.yaml
	@kubectl -n $(NAMESPACE) delete pod -l k8s-app=fluentd-logging

