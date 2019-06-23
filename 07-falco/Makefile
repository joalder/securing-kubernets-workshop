NAMESPACE=monitoring
FLUX_DIR=../flux
FALCO_DIR=falco
FALCO_FLUX_DIR=$(FLUX_DIR)/$(FALCO_DIR)

config:
	@kubectl -n $(NAMESPACE) create configmap falco-config --from-file=falco-config -o yaml --dry-run > manifests/02-falco-configmap.yaml

install: config
	@if [ ! -d "${FALCO_FLUX_DIR}" ]; then mkdir ${FALCO_FLUX_DIR}; fi

	@cp manifests/00-falco-namespace.yaml $(FALCO_FLUX_DIR)
	@cp manifests/01-falco-account.yaml $(FALCO_FLUX_DIR)
	@cp manifests/02-falco-configmap.yaml $(FALCO_FLUX_DIR)
	@cp manifests/03-falco-daemonset.yaml $(FALCO_FLUX_DIR)
	@cp manifests/04-falco-service.yaml $(FALCO_FLUX_DIR)
	@cd $(FLUX_DIR); git add $(FALCO_DIR); git commit -m 'Add Falco'; git push -u origin master
	@fluxctl sync


