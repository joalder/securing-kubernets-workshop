help:
	@echo "deploy-v2: Upgrade existing cURLer app release to v2\n"
	@echo "deploy-v1: Downgrade existing cURLer app release to v1\n"
	@echo "curler-rm: Delete the curler release\n"
	@echo "redeploy-v1: Perform a clean install of cURLer v1\n"
	@echo "redeploy-v2: Perform a clean install of cURLer v2\n"

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

helm-update:
	@helm repo add 4armed http://helm.4armed.io
	helm repo update

deploy-v1: helm-update
	helm upgrade curler 4armed/curler --set global.backend_image=$(CURLER_IMAGE_V1) --reuse-values

deploy-v2: helm-update
	helm upgrade curler 4armed/curler --set global.backend_image=$(CURLER_IMAGE_V2) --reuse-values

redeploy-v1: helm-update
	helm install --name=curler --namespace=curler \
		--set image=eu.gcr.io/$(PROJECT_ID)/curler-fe:v1 \
		--set global.backend_image=eu.gcr.io/$(PROJECT_ID)/curler:v1 \
		--set ingress.hostname=curler.$(ENVIRONMENT_ID).4armed.rocks \
		--set replicaCount=1 \
		--set global.redis.ip=$(REDIS_IP) \
		4armed/curler

redeploy-v2: helm-update
	helm install --name=curler --namespace=curler \
		--set image=eu.gcr.io/$(PROJECT_ID)/curler-fe:v1 \
		--set global.backend_image=eu.gcr.io/$(PROJECT_ID)/curler:v2 \
		--set ingress.hostname=curler.$(ENVIRONMENT_ID).4armed.rocks \
		--set replicaCount=1 \
		--set global.redis.ip=$(REDIS_IP) \
		4armed/curler

ls:
	@helm ls

curler-rm:
	helm delete curler --purge