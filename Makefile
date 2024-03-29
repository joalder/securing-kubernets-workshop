include .env
export

update:
	git pull

# Useful commands
curler-pods:
	kubectl -n curler get pods

curler-pods-rm:
	for label in api worker; do kubectl -n curler delete pods -l app.kubernetes.io/name=$${label}; done

es-pf:
	kubectl -n efk port-forward service/$(ELASTICSEARCH_CLUSTER_NAME)-es 9200

es-status:
	kubectl -n efk get elasticsearches.elasticsearch.k8s.elastic.co

es-health:
	@$(eval PASSWORD=`kubectl -n efk get secret $(ELASTICSEARCH_CLUSTER_NAME)-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode`)
	@curl -u "elastic:$(PASSWORD)" -k https://localhost:9200/_cluster/health?pretty=true

kibana-pf:
	kubectl -n efk port-forward service/$(ELASTICSEARCH_CLUSTER_NAME)-kibana 5601

prom-pf:
	kubectl -n istio-system port-forward service/prometheus 9090

grafana-pf:
	kubectl -n istio-system port-forward service/grafana 3000

kiali-pf:
	kubectl -n istio-system port-forward service/kiali 20001

jaeger-pf:
	kubectl -n istio-system port-forward $$(kubectl -n istio-system get pod -l app=jaeger -o jsonpath='{.items[0].metadata.name}') 15032:16686


flux-logs:
	kubectl -n kube-system logs -l name=flux -f
