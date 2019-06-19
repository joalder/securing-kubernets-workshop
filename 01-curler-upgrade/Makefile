include ../.env
export

CURLER_IMAGE_V1=eu.gcr.io/$(PROJECT_ID)/curler:v1
CURLER_IMAGE_V2=eu.gcr.io/$(PROJECT_ID)/curler:v2

ls:
	helm ls

helm-update:
	helm repo update

deploy-v1: helm-update
	helm upgrade curler 4armed/curler --set global.backend_image=$(CURLER_IMAGE_V1)

deploy-v2: helm-update
	helm upgrade curler 4armed/curler --set global.backend_image=$(CURLER_IMAGE_V2)
