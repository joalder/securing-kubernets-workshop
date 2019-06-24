FLUX_DIR=../flux
CURLER_BASE_DIR=base/curler
CURLER_OVERLAY_DIR=overlays/curler

help:
	@echo "enable-network-policy: Downloads the curler Helm chart, uses kustomize to generate YAML manifest with\n\t\t       network policy enabled. Does not apply it to the cluster\n"
	@echo "install: Performs the above but commits the changes to the flux repo to apply them to the cluster"

include ../.env
export

ifndef ENVIRONMENT_ID
$(error ENVIRONMENT_ID is not set)
endif

ifndef PROJECT_ID
$(error PROJECT_ID is not set)
endif

helm-update:
	@helm repo add 4armed http://helm.4armed.io
	@helm repo update

helm-fetch: helm-update
	@rm curler-*.tgz || exit 0
	@helm fetch 4armed/curler
	@tar xzf curler-*.tgz

curler-dir:
	@if [ ! -d "$(CURLER_BASE_DIR)" ]; then mkdir -p $(CURLER_BASE_DIR); fi
	@if [ ! -d "$(CURLER_OVERLAY_DIR)" ]; then mkdir -p $(CURLER_OVERLAY_DIR); fi
	@echo "resources:\n- curler.yaml" > $(CURLER_BASE_DIR)/kustomization.yaml

helm-template: helm-fetch curler-dir
	@helm template --name=curler --namespace=curler \
			--set image=eu.gcr.io/$(PROJECT_ID)/curler-fe:v1 \
			--set global.backend_image=eu.gcr.io/$(PROJECT_ID)/curler:v2 \
			--set ingress.hostname=curler.$(ENVIRONMENT_ID).4armed.rocks \
			--set replicaCount=1 \
			--set global.redis.ip=$(REDIS_IP) \
			--set ingress.enabled=false \
			--set worker.networkpolicy.enabled=true \
			curler > $(CURLER_BASE_DIR)/curler.yaml

enable-network-policy: helm-template
	@cp kustomize/curler-kustomization.yaml $(CURLER_OVERLAY_DIR)/kustomization.yaml
	@kubectl kustomize $(CURLER_OVERLAY_DIR) > $(FLUX_DIR)/04-curler/01-curler.yaml

install: kustomize-curler
	@echo 
	@cp kustomize/curler-namespace.yaml $(FLUX_DIR)/04-curler/00-namespace.yaml
	@cd $(FLUX_DIR); git add 04-curler; git commit -m 'cURLer update'; git push -u origin master
	@fluxctl sync
