help:
	@echo "install: "

include ../.env
export

create-overlays:
	@EXTERNAL_IP=$(EXTERNAL_IP) envsubst < kustomize/ingress-ip.yaml > overlays/ingress-ip.yaml
	@ENVIRONMENT_ID=$(ENVIRONMENT_ID) envsubst < kustomize/gateway.yaml > overlays/gateway.yaml
	@ENVIRONMENT_ID=$(ENVIRONMENT_ID) envsubst < kustomize/virtualservice.yaml > overlays/virtualservice.yaml

kustomize: create-overlays
	@kubectl kustomize overlays/ > manifests/00-istio.yaml

remove-nginx:
	@if [ $$(helm ls ingress -q | wc -l) -ne 0 ]; then helm delete ingress --purge; fi

check-nginx-ingress: remove-nginx
	@printf "[*] checking nginx-ingress is removed "
	@while [ $$(helm ls ingress -q | wc -l) -ne 0 ]; do printf '.'; sleep 2; done
	@echo " done"

install: kustomize check-nginx-ingress
	# To force recreation with the correct IP
	@kubectl -n istio-system delete service istio-ingressgateway
	@kubectl apply -f manifests/00-istio.yaml

loadbalancer-ip:
	@echo $(EXTERNAL_IP)
