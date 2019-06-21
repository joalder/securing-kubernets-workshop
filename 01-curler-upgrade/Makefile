include ../.env
export

ifndef ENVIRONMENT_ID
$(error ENVIRONMENT_ID is not set)
endif

ifndef PROJECT_ID
$(error PROJECT_ID is not set)
endif

CURLER_IMAGE_V1=eu.gcr.io/$(PROJECT_ID)/curler:v1
CURLER_IMAGE_V2=eu.gcr.io/$(PROJECT_ID)/curler:v2

ls:
	helm ls

helm-update:
	helm repo add 4armed http://helm.4armed.io
	helm repo update

deploy-v1: helm-update
	helm upgrade curler 4armed/curler --set global.backend_image=$(CURLER_IMAGE_V1) --reuse-values

deploy-v2: helm-update
	helm upgrade curler 4armed/curler --set global.backend_image=$(CURLER_IMAGE_V2) --reuse-values
