NAMESPACE=efk

config-fluentd:
	@kubectl -n $(NAMESPACE) create configmap fluentd-config --from-file=fluentd-etc -o yaml --dry-run > manifests/03-fluentd-configmap.yaml

install: config-fluentd
	@kubectl apply -f manifests/00-elastic-crds.yaml
	@kubectl apply -f manifests/01-elastic-cluster.yaml
	@kubectl apply -f manifests/02-kibana.yaml
	@kubectl apply -f manifests/03-fluentd-configmap.yaml
	@kubectl apply -f manifests/04-fluentd.yaml

kibana-password:
	@kubectl -n efk get secret azathoth-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo

reconfigure-fluentd:
	@kubectl -n $(NAMESPACE) create configmap fluentd-config --from-file=fluentd-etc -o yaml --dry-run > manifests/03-fluentd-configmap.yaml
	@kubectl apply -f manifests/03-fluentd-configmap.yaml
	@kubectl apply -f manifests/04-fluentd.yaml
	@kubectl -n $(NAMESPACE) delete pod -l k8s-app=fluentd-logging

