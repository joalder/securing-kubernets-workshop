include ../.env
export

ifndef ENVIRONMENT_ID
$(error ENVIRONMENT_ID is not set)
endif

ifndef PROJECT_ID
$(error PROJECT_ID is not set)
endif

FLUX_VERSION=1.13.0
FLUX_DEPLOY_DIR=base
FLUX_SSH_PUB_KEY=flux-ssh-key.pub

download-flux:
	@if [ -d "./${FLUX_DEPLOY_DIR}" ]; then rm -rf ./${FLUX_DEPLOY_DIR}; mkdir ./$(FLUX_DEPLOY_DIR); else mkdir ./$(FLUX_DEPLOY_DIR); fi
	@curl -sL https://github.com/weaveworks/flux/archive/$(FLUX_VERSION).tar.gz | $(TAR) xz -f - -C ${FLUX_DEPLOY_DIR} flux-$(FLUX_VERSION)/deploy --strip-components=2

create-overlays:
	@cp kustomize/flux-kustomization.yaml $(FLUX_DEPLOY_DIR)/kustomization.yaml
	@ENVIRONMENT_ID=$(ENVIRONMENT_ID) PROJECT_ID=$(PROJECT_ID) envsubst < kustomize/flux-deployment.yaml > overlays/deployment.yaml

kustomize: create-overlays
	@kubectl kustomize overlays/ > manifests/00-flux.yaml

install: kustomize
	@kubectl apply -f manifests/
	@fluxctl identity > $(FLUX_SSH_PUB_KEY)
	@echo "\nAdd the following public key at https://source.cloud.google.com/user/ssh_keys?register=true\n"
	@cat $(FLUX_SSH_PUB_KEY)

clone:
	@gcloud source repos clone flux --project=$(PROJECT_ID)
