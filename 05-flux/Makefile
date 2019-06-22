include ../.env
export

ifndef ENVIRONMENT_ID
$(error ENVIRONMENT_ID is not set)
endif

ifndef PROJECT_ID
$(error PROJECT_ID is not set)
endif


download-flux:
	git clone https://github.com/weaveworks/flux

create-overlays:
	@ENVIRONMENT_ID=$(ENVIRONMENT_ID) PROJECT_ID=$(PROJECT_ID) envsubst < kustomize/flux-deployment.yaml > overlays/deployment.yaml

