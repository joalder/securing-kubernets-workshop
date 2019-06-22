install:
	[ -d manifests ] && kubectl apply -f manifests

uninstall:
	kubectl delete -f manifests

repo:
	helm repo add 4armed http://helm.4armed.io

redis-monitoring: repo
	helm --tiller-namespace=helm upgrade curler 4armed/curler --set redis.metrics.serviceMonitor.enabled=true

ingress-monitoring:
	helm --tiller-namespace=helm upgrade ingress stable/nginx-ingress --set controller.metrics.enabled=true --set controller.metrics.serviceMonitor.enabled=true
