 export LC_CTYPE=C
#  MONITORING_NAMESPACE=monitoring
#  NAMESPACE_FILE=00-namespace.yaml
#  MONITORING_YAML=01-monitoring.yaml

# fetch:
# 	helm fetch stable/prometheus-operator
# 	tar xzf prometheus-operator-*.tgz

# yaml:
# 	@$(eval GRAFANA_PASSWORD=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''`)
# 	@echo $(GRAFANA_PASSWORD)
# 	helm template prometheus-operator --name=monitoring --set grafana.adminPassword=$(GRAFANA_PASSWORD) --set coreDns.enabled=false --set kubeDns.enabled=true > $(MONITORING_YAML)

apply:
	[ -d manifests ] && kubectl apply -f manifests

delete:
	kubectl delete -f manifests

repo:
	helm repo add 4armed http://helm.4armed.io

redis-monitoring: repo
	helm --tiller-namespace=helm upgrade curler 4armed/curler --set redis.metrics.serviceMonitor.enabled=true

ingress-monitoring:
	helm --tiller-namespace=helm upgrade ingress stable/nginx-ingress --set controller.metrics.enabled=true --set controller.metrics.serviceMonitor.enabled=true
