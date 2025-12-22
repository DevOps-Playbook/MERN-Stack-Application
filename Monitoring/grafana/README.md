# Grafana Helm Chart

> Grafana is a powerful dashboard and visualization tool that integrates with Prometheus to provide rich, customizable visualizations of the metrics data, we can instal the web dashboarding system from [here](http://grafana.org/)

## Prerequisites:
1. A running Kubernetes cluster
2. Helm installed and configured


## Get Repo Info

```console
git clone https://github.com/grafana/helm-charts.git
cd observability-setup/grafana
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Installing the Chart

1. Enable grafana
2. Add correct annotations to fetch the required labels
3. Setup ingress or target group binding for the pods

```console
helm install grafana ./ -n default -f <values.yaml>
```

## Decode the Grafana password
```console
kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

## Setup Datasources

1. Navigate to Grafana Dashboard
2. Add datasource as "prometheus"
3. URL - http://prometheus-kube-prometheus-prometheus:9090
4. Test connection

## Uninstalling the Chart

To uninstall/delete deployment:

```console
helm delete grafana
```


## Upgrading an existing Release to a new major version

A major chart version change (like v1.2.3 -> v2.0.0) indicates that there is an
incompatible breaking change needing manual actions.

### To 4.0.0 (And 3.12.1)

This version requires Helm >= 2.12.0.

### To 5.0.0

You have to add --force to your helm upgrade command as the labels of the chart have changed.

### To 6.0.0

This version requires Helm >= 3.1.0.

### To 7.0.0

For consistency with other Helm charts, the `global.image.registry` parameter was renamed
to `global.imageRegistry`. If you were not previously setting `global.image.registry`, no action
is required on upgrade. If you were previously setting `global.image.registry`, you will
need to instead set `global.imageRegistry`.

## Configuration

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `replicas`                                | Number of nodes                               | `1`                                                     |
| `podDisruptionBudget.minAvailable`        | Pod disruption minimum available              | `nil`                                                   |
| `podDisruptionBudget.maxUnavailable`      | Pod disruption maximum unavailable            | `nil`                                                   |
| `podDisruptionBudget.apiVersion`          | Pod disruption apiVersion                     | `nil`                                                   |
| `deploymentStrategy`                      | Deployment strategy                           | `{ "type": "RollingUpdate" }`                           |
| `livenessProbe`                           | Liveness Probe settings                       | `{ "httpGet": { "path": "/api/health", "port": 3000 } "initialDelaySeconds": 60, "timeoutSeconds": 30, "failureThreshold": 10 }` |
| `readinessProbe`                          | Readiness Probe settings                      | `{ "httpGet": { "path": "/api/health", "port": 3000 } }`|
| `securityContext`                         | Deployment securityContext                    | `{"runAsUser": 472, "runAsGroup": 472, "fsGroup": 472}`  |
| `priorityClassName`                       | Name of Priority Class to assign pods         | `nil`                                                   |
| `image.registry`                          | Image registry                                | `docker.io`                                       |
| `image.repository`                        | Image repository                              | `grafana/grafana`                                       |
| `image.tag`                               | Overrides the Grafana image tag whose default is the chart appVersion (`Must be >= 5.0.0`) | ``                                                      |
| `image.sha`                               | Image sha (optional)                          | ``                                                      |
| `image.pullPolicy`                        | Image pull policy                             | `IfNotPresent`                                          |
| `image.pullSecrets`                       | Image pull secrets (can be templated)         | `[]`                                                    |
| `service.enabled`                         | Enable grafana service                        | `true`                                                  |
| `service.ipFamilies`                      | Kubernetes service IP families                | `[]`                                                    |
| `service.ipFamilyPolicy`                  | Kubernetes service IP family policy           | `""`                                                    |
| `service.sessionAffinity`                 | Kubernetes service session affinity config    | `""`                                                    |
| `service.type`                            | Kubernetes service type                       | `ClusterIP`                                             |
| `service.port`                            | Kubernetes port where service is exposed      | `80`                                                    |
| `service.portName`                        | Name of the port on the service               | `service`                                               |
| `service.appProtocol`                     | Adds the appProtocol field to the service     | ``                                                      |
| `service.targetPort`                      | Internal service is port                      | `3000`                                                  |


## Import dashboards

There are a few methods to import dashboards to Grafana. Below are some examples and explanations as to how to use each method:

```yaml
dashboards:
  default:
    some-dashboard:
      json: |
        {
          "annotations":

          ...
          # Complete json file here
          ...

          "title": "Some Dashboard",
          "uid": "abcd1234",
          "version": 1
        }
    custom-dashboard:
      # This is a path to a file inside the dashboards directory inside the chart directory
      file: dashboards/custom-dashboard.json
    prometheus-stats:
      # Ref: https://grafana.com/dashboards/2
      gnetId: 2
      revision: 2
      datasource: Prometheus
    loki-dashboard-quick-search:
      gnetId: 12019
      revision: 2
      datasource:
      - name: DS_PROMETHEUS
        value: Prometheus
      - name: DS_LOKI
        value: Loki
    local-dashboard:
      url: https://raw.githubusercontent.com/user/repository/master/dashboards/dashboard.json
```

## BASE64 dashboards

Dashboards could be stored on a server that does not return JSON directly and instead of it returns a Base64 encoded file (e.g. Gerrit)
A new parameter has been added to the url use case so if you specify a b64content value equals to true after the url entry a Base64 decoding is applied before save the file to disk.
If this entry is not set or is equals to false not decoding is applied to the file before saving it to disk.

### Gerrit use case

Gerrit API for download files has the following schema: <https://yourgerritserver/a/{project-name}/branches/{branch-id}/files/{file-id}/content> where {project-name} and
{file-id} usually has '/' in their values and so they MUST be replaced by %2F so if project-name is user/repo, branch-id is master and file-id is equals to dir1/dir2/dashboard
the url value is <https://yourgerritserver/a/user%2Frepo/branches/master/files/dir1%2Fdir2%2Fdashboard/content>

## Sidecar for dashboards

If the parameter `sidecar.dashboards.enabled` is set, a sidecar container is deployed in the grafana
pod. This container watches all configmaps (or secrets) in the cluster and filters out the ones with
a label as defined in `sidecar.dashboards.label`. The files defined in those configmaps are written
to a folder and accessed by grafana. Changes to the configmaps are monitored and the imported
dashboards are deleted/updated.

A recommendation is to use one configmap per dashboard, as a reduction of multiple dashboards inside
one configmap is currently not properly mirrored in grafana.

Example dashboard config:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: sample-grafana-dashboard
  labels:
    grafana_dashboard: "1"
data:
  k8s-dashboard.json: |-
  [...]
```

## Sidecar for datasources

If the parameter `sidecar.datasources.enabled` is set, an init container is deployed in the grafana
pod. This container lists all secrets (or configmaps, though not recommended) in the cluster and
filters out the ones with a label as defined in `sidecar.datasources.label`. The files defined in
those secrets are written to a folder and accessed by grafana on startup. Using these yaml files,
the data sources in grafana can be imported.

Should you aim for reloading datasources in Grafana each time the config is changed, set `sidecar.datasources.skipReload: false` and adjust `sidecar.datasources.reloadURL` to `http://<svc-name>.<namespace>.svc.cluster.local/api/admin/provisioning/datasources/reload`.

Secrets are recommended over configmaps for this usecase because datasources usually contain private
data like usernames and passwords. Secrets are the more appropriate cluster resource to manage those.

Example values to add a postgres datasource as a kubernetes secret:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: grafana-datasources
  labels:
    grafana_datasource: 'true' # default value for: sidecar.datasources.label
stringData:
  pg-db.yaml: |-
    apiVersion: 1
    datasources:
      - name: My pg db datasource
        type: postgres
        url: my-postgresql-db:5432
        user: db-readonly-user
        secureJsonData:
          password: 'SUperSEcretPa$$word'
        jsonData:
          database: my_datase
          sslmode: 'disable' # disable/require/verify-ca/verify-full
          maxOpenConns: 0 # Grafana v5.4+
          maxIdleConns: 2 # Grafana v5.4+
          connMaxLifetime: 14400 # Grafana v5.4+
          postgresVersion: 1000 # 903=9.3, 904=9.4, 905=9.5, 906=9.6, 1000=10
          timescaledb: false
        # <bool> allow users to edit datasources from the UI.
        editable: false
```



### High Availability for unified alerting

If you want to run Grafana in a high availability cluster you need to enable
the headless service by setting `headlessService: true` in your `values.yaml`
file.

As next step you have to setup the `grafana.ini` in your `values.yaml` in a way
that it will make use of the headless service to obtain all the IPs of the
cluster. You should replace ``{{ Name }}`` with the name of your helm deployment.

```yaml
grafana.ini:
  ...
  unified_alerting:
    enabled: true
    ha_peers: {{ Name }}-headless:9094
    ha_listen_address: ${POD_IP}:9094
    ha_advertise_address: ${POD_IP}:9094
    rule_version_record_limit: "5"

  alerting:
    enabled: false
```
