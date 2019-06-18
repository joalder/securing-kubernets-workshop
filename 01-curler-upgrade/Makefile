include ../.env
export

CURLER_IMAGE_V1=eu.gcr.io/$(PROJECT_ID)/curler:v1
CURLER_IMAGE_V2=eu.gcr.io/$(PROJECT_ID)/curler:v2

ls:
	helm ls

deploy-v1:
	helm upgrade curler 4armed/curler --set api.image=$(CURLER_IMAGE_V1) --set worker.image=$(CURLER_IMAGE_V1)

deploy-v2:
	helm upgrade curler 4armed/curler --set api.image=$(CURLER_IMAGE_V2) --set worker.image=$(CURLER_IMAGE_V2)
