include ../.env
export

ifndef ENVIRONMENT_ID
$(error ENVIRONMENT_ID is not set)
endif

ifndef PROJECT_ID
$(error PROJECT_ID is not set)
endif

CURLER_IMAGE_V2=eu.gcr.io/$(PROJECT_ID)/curler:v2

helm-update:
	helm repo add 4armed http://helm.4armed.io
	helm repo update

shift-workload: helm-update
	helm upgrade curler 4armed/curler \
		--reuse-values \
		--set worker.nodeSelector.cloud.google.com/gke-nodepool=secure-pool

create-cluster-one:
	@gcloud beta container --project "${PROJECT_ID}" clusters create "one" \
		 --zone "europe-west3-a" \
		 --no-enable-basic-auth \
		 --machine-type "n1-standard-1" \
		 --image-type "COS" \
		 --disk-type "pd-standard" \
		 --disk-size "30" \
		 --metadata disable-legacy-endpoints=true \
		 --scopes "https://www.googleapis.com/auth/devstorage.read_only" \
		 --preemptible --num-nodes "1" \
		 --no-enable-cloud-logging \
		 --no-enable-cloud-monitoring \
		 --enable-ip-alias \
		 --network "projects/${PROJECT_ID}/global/networks/workshop-0" \
		 --subnetwork "projects/${PROJECT_ID}/regions/europe-west3/subnetworks/workshop-0" \
		 --cluster-secondary-range-name "workshop-0-pods" \
		 --services-secondary-range-name "workshop-0-services" \
		 --default-max-pods-per-node "50" \
		 --enable-autoscaling \
		 --min-nodes "1" \
		 --max-nodes "3" \
		 --enable-network-policy \
		 --addons HorizontalPodAutoscaling,HttpLoadBalancing \
		 --enable-autoupgrade \
		 --enable-autorepair \
		 --enable-binauthz \
		 --identity-namespace "${PROJECT_ID}.svc.id.goog"