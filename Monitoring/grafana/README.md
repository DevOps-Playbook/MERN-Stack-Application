# Grafana Helm Chart

> Grafana is a powerful dashboard and visualization tool that integrates with Prometheus to provide rich, customizable visualizations of the metrics data, we can instal the web dashboarding system from [here](http://grafana.org/)

## Prerequisites:
1. A running Kubernetes cluster
2. Helm installed and configured


## Get Repo Info

```console
git clone https://github.com/DevOps-Playbook/MERN-Stack-Application.git
cd grafana
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Installing the Chart

```console
helm upgrade --install grafana .
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
