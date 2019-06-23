help:
	@echo "shift-workload: Patches the curler-worker deployment's nodeSelector so that the pod moves to the secure node pool\n"

include ../.env
export

ifndef ENVIRONMENT_ID
$(error ENVIRONMENT_ID is not set)
endif

ifndef PROJECT_ID
$(error PROJECT_ID is not set)
endif

CURLER_IMAGE_V2=eu.gcr.io/$(PROJECT_ID)/curler:v2

shift-workload:
	@kubectl -n curler patch deployments curler-worker -p '{"spec": {"template": {"spec": {"nodeSelector": {"cloud.google.com/gke-nodepool": "secure-pool"}}}}}'