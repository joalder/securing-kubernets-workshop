export ISTIO_VERSION=1.2.0

download:
	@curl -L https://git.io/getLatestIstio | sh -

istio-init:
	@helm template istio-$(ISTIO_VERSION)/install/kubernetes/helm/istio-init --name istio-init --namespace istio-system --set certmanager.enabled=true > manifests/01-istio-init.yaml

istio-cni:
	@helm template istio-$(ISTIO_VERSION)/install/kubernetes/helm/istio-cni --name=istio-cni --namespace=istio-system -f istio-$(ISTIO_VERSION)/install/kubernetes/helm/istio-cni/values_gke.yaml > manifests/02-istio-cni.yaml

istio-init-check:
	@printf "[*] checking Istio CRDs "
	@while [ $$(kubectl get crds | grep 'istio.io\|certmanager.k8s.io' | wc -l) -ne 28 ]; do printf '.'; sleep 2; done
	@echo " done"

istio-prepare: istio-init
	@kubectl apply -f manifests/00-namespace.yaml
	@kubectl apply -f manifests/01-istio-init.yaml

istio:
	@helm template istio-$(ISTIO_VERSION)/install/kubernetes/helm/istio --name istio --namespace istio-system -f values.yaml > manifests/03-istio.yaml

install: istio-prepare istio-init-check
	@kubectl apply -f manifests/02-istio-cni.yaml
	@kubectl apply -f manifests/03-istio.yaml

uninstall:
	@kubectl delete -f manifests/03-istio.yaml
	@kubectl delete -f manifests/02-istio-cni.yaml
	@kubectl delete -f manifests/01-istio-init.yaml
	@kubectl delete -f manifests/00-namespace.yaml

enable-curler-sidecar:
	@kubectl label namespace curler istio-injection=enabled
	@kubectl -n curler delete pods -l app=redis
	@kubectl -n curler delete pods -l app=nginx-ingress
	@kubectl -n curler delete pods -l app.kubernetes.io/instance=curler

istio-prometheus:
	@kubectl -n monitoring create secret generic istio-prometheus-config --from-file=./istio-prometheus-scrape-config.yaml --dry-run -o yaml > manifests/04-istio-prometheus-config.yaml
	@kubectl apply -f manifests/04-istio-prometheus-config.yaml
	@kubectl apply -f manifests/05-prometheus-roleSpecificNamespaces.yaml
	@kubectl apply -f manifests/06-prometheus-roleBindingSpecificNamespaces.yaml
	@kubectl apply -f manifests/07-prometheus.yaml

