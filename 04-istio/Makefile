export ISTIO_VERSION=1.1.9

download:
	@curl -L https://git.io/getLatestIstio | sh -

istio-init:
	@helm template istio-$(ISTIO_VERSION)/install/kubernetes/helm/istio-init --name istio-init --namespace istio-system > manifests/01-istio-init.yaml

istio-cni:
	@helm repo add istio.io https://storage.googleapis.com/istio-release/releases/1.1.9/charts/
	@helm repo update
	@helm fetch istio.io/istio-cni
	@tar -xzf istio-cni*.tgz
	@helm template istio-cni --name=istio-cni --namespace=istio-system -f istio-cni/values_gke.yaml > manifests/02-istio-cni.yaml

istio:
	@helm template istio-$(ISTIO_VERSION)/install/kubernetes/helm/istio --name istio --namespace istio-system \
		--set istio_cni.enabled=true