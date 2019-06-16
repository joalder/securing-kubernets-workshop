include ../.env
export

ls:
	helm ls

deploy-v2:
	helm upgrade curler 4armed/curler --set api.image=eu.gcr.io/$(PROJECT_ID)/curler:v2 --set worker.image=eu.gcr.io/$(PROJECT_ID)/curler:v2