NAMESPACE=efk

help:
	@echo "install-operator: Installs the Elastic Operator into the elastic-system namespace\n"
	@echo "install-es: Installs an Elasticsearch cluster with a single node and PVC\n"
	@echo "install-kf: Installs an instance of Kibana and creates a Fluentd Daemonset to send \n\tlogs from each node to our Elasticsearch cluster\n"
	@echo "kibana-password: Retrieves the randomly generated password for Kibana from the Kubernetes Secret\n"
	@echo "delete-es-pods: Delete the Elasticsearch pods"

install-operator:
	kubectl apply -f manifests/00-elastic-operator.yaml
	@echo "[*] wait for Operator to come up"
	@echo "[*] use: kubectl -n elastic-system logs -f statefulset.apps/elastic-operator"
	@echo "[*] then: make install-es"

install-es:
	kubectl apply -f manifests/01-elastic-cluster.yaml

config-fluentd:
	kubectl -n $(NAMESPACE) create configmap fluentd-config --from-file=fluentd-etc -o yaml --dry-run > manifests/03-fluentd-configmap.yaml

install-kf: config-fluentd
	kubectl apply -f manifests/02-kibana.yaml
	kubectl apply -f manifests/03-fluentd-configmap.yaml
	kubectl apply -f manifests/04-fluentd.yaml

kibana-password:
	kubectl -n efk get secret azathoth-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo

reconfigure-fluentd:
	kubectl -n $(NAMESPACE) create configmap fluentd-config --from-file=fluentd-etc -o yaml --dry-run > manifests/03-fluentd-configmap.yaml
	kubectl apply -f manifests/03-fluentd-configmap.yaml
	kubectl apply -f manifests/04-fluentd.yaml
	kubectl -n $(NAMESPACE) delete pod -l k8s-app=fluentd-logging

delete-es-pods:
	kubectl -n efk delete pods -l elasticsearch.k8s.elastic.co/cluster-name=azathoth
