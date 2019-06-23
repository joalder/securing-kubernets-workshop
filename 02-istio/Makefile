export ISTIO_VERSION=1.2.0
GRAFANA_DASHBOARD_CONFIGMAP_FILE=manifests/07-istio-grafana-dashboards.yaml
GRAFANA_DEPLOYMENT_FILE=manifests/08-grafana-deployment.yaml
GRAFANA_CONFIGMAPS_FILE=grafana-deployment-configmaps.yaml
GRAFANA_VOLUMES_FILE=grafana-deployment-volumes.yaml

help:
	@echo "install: Downloads Istio $(ISTIO_VERSION), installs the init CRDs, CNI networking and main Istio components\n"
	@echo "enable-curler-sidecar: Labels the curler namespace to enable Istio sidecar injection then \n\tdeletes the pods to force their recreation with the sidecar\n"
	@echo "uninstall: Removes Istio from the cluster\n"

download:
	@curl -L https://git.io/getLatestIstio | sh -

istio-init: download
	@helm template istio-$(ISTIO_VERSION)/install/kubernetes/helm/istio-init --name istio-init --namespace istio-system --set certmanager.enabled=true > manifests/01-istio-init.yaml

istio-cni:
	@helm template istio-$(ISTIO_VERSION)/install/kubernetes/helm/istio-cni --name=istio-cni --namespace=kube-system -f istio-$(ISTIO_VERSION)/install/kubernetes/helm/istio-cni/values_gke.yaml > manifests/02-istio-cni.yaml

istio-init-check:
	@printf "[*] checking Istio CRDs "
	@while [ $$(kubectl get crds | grep 'istio.io\|certmanager.k8s.io' | wc -l) -ne 28 ]; do printf '.'; sleep 2; done
	@echo " done"

istio-prepare: istio-init
	@kubectl apply -f manifests/00-namespace.yaml
	@kubectl apply -f manifests/01-istio-init.yaml

istio:
	@helm template istio-$(ISTIO_VERSION)/install/kubernetes/helm/istio --name istio --namespace istio-system -f istio-values.yaml > manifests/03-istio.yaml

install: istio-prepare istio-init-check istio-cni istio
	@kubectl apply -f manifests/02-istio-cni.yaml
	@kubectl apply -f manifests/02-kiali-secret.yaml
	@kubectl apply -f manifests/03-istio.yaml

uninstall:
	@kubectl delete -f manifests/03-istio.yaml
	@kubectl delete -f manifests/02-istio-cni.yaml
	@kubectl delete -f manifests/01-istio-init.yaml
	@kubectl delete -f manifests/00-namespace.yaml

enable-curler-sidecar:
	@kubectl label namespace curler istio-injection=enabled
	@kubectl -n curler delete pods -l app=nginx-ingress
	@kubectl -n curler delete pods -l app.kubernetes.io/instance=curler