NAMESPACE=monitoring

config:
	@kubectl -n $(NAMESPACE) create configmap falco-config --from-file=falco-config -o yaml --dry-run > 02-falco-configmap.yaml

install: config
	@kubectl apply -f 00-falco-namespace.yaml
	@kubectl apply -f 01-falco-account.yaml
	@kubectl apply -f 02-falco-configmap.yaml
	@kubectl apply -f 03-falco-daemonset.yaml
	@kubectl apply -f 04-falco-service.yaml

