export ISTIO_VERSION=1.2.0
GRAFANA_DASHBOARD_CONFIGMAP_FILE=manifests/07-istio-grafana-dashboards.yaml
GRAFANA_DEPLOYMENT_FILE=manifests/08-grafana-deployment.yaml
GRAFANA_CONFIGMAPS_FILE=grafana-deployment-configmaps.yaml
GRAFANA_VOLUMES_FILE=grafana-deployment-volumes.yaml

download:
	@curl -L https://git.io/getLatestIstio | sh -

istio-init:
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

istio-prometheus:
	@kubectl -n monitoring create secret generic istio-prometheus-config --from-file=./istio-prometheus-scrape-config.yaml --dry-run -o yaml > manifests/04-istio-prometheus-config.yaml
	@kubectl apply -f manifests/04-istio-prometheus-config.yaml
	@kubectl apply -f manifests/05-prometheus.yaml

# I'm not proud of this hacky echo stuff. There's probably a more make-like way to do it.
grafana-dashboard-configmaps:
	@cp kustomize/$(GRAFANA_CONFIGMAPS_FILE) overlays/
	@cp kustomize/$(GRAFANA_VOLUMES_FILE) overlays/
	@cat /dev/null > $(GRAFANA_DASHBOARD_CONFIGMAP_FILE)
	@for dashboard in istio-1.2.0/install/kubernetes/helm/istio/charts/grafana/dashboards/*.json; do \
		configmap_name=`basename $${dashboard} | sed -e 's/\.json//'`; \
		echo "---" >> $(GRAFANA_DASHBOARD_CONFIGMAP_FILE) ; \
		kubectl -n monitoring create configmap grafana-$${configmap_name} --from-file=$${dashboard} --dry-run -o yaml >> $(GRAFANA_DASHBOARD_CONFIGMAP_FILE) ; \
		echo "        - mountPath: /grafana-dashboard-definitions/istio/$${configmap_name}\n          name: grafana-$${configmap_name}" >> overlays/$(GRAFANA_CONFIGMAPS_FILE) ; \
		echo "      - configMap:\n          name: grafana-$${configmap_name}\n        name: grafana-$${configmap_name}" >> overlays/$(GRAFANA_VOLUMES_FILE) ; \
	done
	@kubectl kustomize overlays/ > $(GRAFANA_DEPLOYMENT_FILE)

grafana-dashboard-install: grafana-dashboard-configmaps
	@kubectl apply -f manifests/06-istio-grafana-dashboard-provisioning.yaml
	@kubectl apply -f manifests/07-istio-grafana-dashboards.yaml
	@kubectl apply -f manifests/08-grafana-deployment.yaml