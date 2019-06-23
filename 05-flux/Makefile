include ../.env
export

ifndef ENVIRONMENT_ID
$(error ENVIRONMENT_ID is not set)
endif

ifndef PROJECT_ID
$(error PROJECT_ID is not set)
endif

FLUX_DIR=../flux
FLUX_VERSION=1.13.0
FLUX_BASE_DIR=base/flux
FLUX_OVERLAY_DIR=overlays/flux
FLUX_SSH_PUB_KEY=flux-ssh-key.pub
CURLER_BASE_DIR=base/curler
CURLER_OVERLAY_DIR=overlays/curler

download-flux:
	@if [ -d "./${FLUX_BASE_DIR}" ]; then rm -rf ./${FLUX_BASE_DIR}; mkdir -p ./$(FLUX_BASE_DIR); else mkdir -p ./$(FLUX_BASE_DIR); fi
	@curl -sL https://github.com/weaveworks/flux/archive/$(FLUX_VERSION).tar.gz | $(TAR) xz -f - -C ${FLUX_BASE_DIR} flux-$(FLUX_VERSION)/deploy --strip-components=2

create-overlays:
	@cp kustomize/flux-kustomization.yaml $(FLUX_BASE_DIR)/kustomization.yaml
	@ENVIRONMENT_ID=$(ENVIRONMENT_ID) PROJECT_ID=$(PROJECT_ID) envsubst < kustomize/flux-deployment.yaml > $(FLUX_OVERLAY_DIR)/deployment.yaml

kustomize-flux: create-overlays
	@kubectl kustomize $(FLUX_OVERLAY_DIR) > manifests/00-flux.yaml

install: kustomize
	@kubectl apply -f manifests/
	@fluxctl identity > $(FLUX_SSH_PUB_KEY)
	@echo "\nAdd the following public key at https://source.cloud.google.com/user/ssh_keys?register=true\n"
	@cat $(FLUX_SSH_PUB_KEY)

clone:
	@echo "Flux directory is $(FLUX_DIR)"
	@gcloud source repos clone flux $(FLUX_DIR) --project=$(PROJECT_ID)

copy-manifests:
	@for i in 00-efk 03-ingress; do mkdir $(FLUX_DIR)/$$i; cp ../$$i/manifests/*.yaml $(FLUX_DIR)/$$i/; done
	@echo "Manifests copied to $(FLUX_DIR)"
	@echo "Now add and commit them"
	@echo "cd $(FLUX_DIR)"
	@echo "git add ."
	@echo "git commit -m 'Initial commit'"
	@echo "git push -u origin master"
	@echo "Now we wait for a Flux reconciliation loop. Max 5 minutes."
	@echo kubectl -n kube-system logs -l name=flux -f

helm-update:
	@helm repo add 4armed http://helm.4armed.io
	@helm repo update

helm-fetch: helm-update
	@rm curler-*.tgz
	@helm fetch 4armed/curler
	@tar xzf curler-*.tgz

helm-reset:
	@helm --tiller-namespace=helm reset
	@kubectl delete ns helm

curler-rm:
	helm delete curler --purge

curler-dir:
	@if [ ! -d "$(CURLER_BASE_DIR)" ]; then mkdir -p $(CURLER_BASE_DIR); fi
	@if [ ! -d "$(CURLER_OVERLAY_DIR)" ]; then mkdir -p $(CURLER_OVERLAY_DIR); fi
	@if [ ! -d "$(FLUX_DIR)/04-curler" ]; then mkdir $(FLUX_DIR)/04-curler; fi
	@echo "resources:\n- curler.yaml" > $(CURLER_BASE_DIR)/kustomization.yaml

helm-template: helm-fetch curler-dir
	@helm template --name=curler --namespace=curler \
			--set image=eu.gcr.io/$(PROJECT_ID)/curler-fe:v1 \
			--set global.backend_image=eu.gcr.io/$(PROJECT_ID)/curler:v2 \
			--set ingress.hostname=curler.$(ENVIRONMENT_ID).4armed.rocks \
			--set replicaCount=1 \
			--set global.redis.ip=$(REDIS_IP) \
			--set ingress.enabled=false \
			curler > $(CURLER_BASE_DIR)/curler.yaml

kustomize-curler: helm-template
	@cp kustomize/curler-kustomization.yaml $(CURLER_OVERLAY_DIR)/kustomization.yaml
	@kubectl kustomize $(CURLER_OVERLAY_DIR) > $(FLUX_DIR)/04-curler/01-curler.yaml

curler: kustomize-curler
	@echo 
	@cp kustomize/curler-namespace.yaml $(FLUX_DIR)/04-curler/00-namespace.yaml
	@cd $(FLUX_DIR); git add 04-curler; git commit -m 'cURLer update'; git push -u origin master
	@fluxctl sync
