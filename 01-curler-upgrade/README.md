# Upgrade Curler to v2

In order to patch the command execution issue the devs have released version of the worker. We need to deploy this by upgrading the package with Helm.

```bash
make deploy-v2
helm upgrade curler 4armed/curler --set api.image=eu.gcr.io/securing-gke-0/curler:v2 --set worker.image=eu.gcr.io/securing-gke-0/curler:v2
Release "curler" has been upgraded.
LAST DEPLOYED: Fri Jun 14 15:38:29 2019
NAMESPACE: curler
STATUS: DEPLOYED

RESOURCES:
==> v1/ConfigMap
NAME                 DATA  AGE
curler-config        1     9m42s
curler-redis         3     9m43s
curler-redis-health  3     9m43s

==> v1/Deployment
NAME           READY  UP-TO-DATE  AVAILABLE  AGE
curler         1/1    1           1          9m42s
curler-api     1/1    1           1          9m42s
curler-worker  2/2    1           2          9m42s

==> v1/Pod(related)
NAME                                   READY  STATUS             RESTARTS  AGE
curler-669c758964-4zjcl                1/1    Running            0         9m42s
curler-api-78cd88d6b4-6jx46            0/1    ContainerCreating  0         2s
curler-api-c6f96dc4c-zb2sb             1/1    Running            0         6m47s
curler-redis-master-0                  1/1    Running            0         9m42s
curler-redis-metrics-648f8c9c6c-8h7sm  1/1    Running            0         9m42s
curler-redis-slave-0                   1/1    Running            0         9m42s
curler-redis-slave-1                   1/1    Running            0         9m8s
curler-worker-5d657f6688-77s26         1/1    Running            0         6m42s
curler-worker-5d657f6688-fsv6d         1/1    Running            0         6m43s
curler-worker-75fc5cfdbf-f88j8         0/1    ContainerCreating  0         2s

==> v1/Service
NAME                   TYPE       CLUSTER-IP   EXTERNAL-IP  PORT(S)   AGE
curler                 ClusterIP  10.0.14.16   <none>       80/TCP    9m42s
curler-api             ClusterIP  10.0.12.92   <none>       1337/TCP  9m42s
curler-redis-headless  ClusterIP  None         <none>       6379/TCP  9m42s
curler-redis-master    ClusterIP  10.0.12.201  <none>       6379/TCP  9m42s
curler-redis-metrics   ClusterIP  10.0.15.0    <none>       9121/TCP  9m42s
curler-redis-slave     ClusterIP  10.0.13.146  <none>       6379/TCP  9m42s

==> v1beta1/Deployment
NAME                  READY  UP-TO-DATE  AVAILABLE  AGE
curler-redis-metrics  1/1    1           1          9m42s

==> v1beta1/Ingress
NAME    HOSTS                  ADDRESS        PORTS  AGE
curler  curler.0.4armed.rocks  35.242.205.87  80     9m42s

==> v1beta2/StatefulSet
NAME                 READY  AGE
curler-redis-master  1/1    9m42s
curler-redis-slave   2/2    9m42s
```
