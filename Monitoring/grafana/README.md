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
<img width="1406" height="552" alt="Screenshot 2025-12-23 at 11 11 01 AM" src="https://github.com/user-attachments/assets/58922b16-953b-4b8d-b9ab-6eac8c1832d1" />


## Decode the Grafana password
```console
kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
## Login to Admin page

<img width="1440" height="583" alt="Screenshot 2025-12-23 at 11 12 56 AM" src="https://github.com/user-attachments/assets/fee71ef3-4986-4356-9fec-f9e21219e3d1" />


## Setup Datasources

1. Navigate to Grafana Dashboard
2. Add datasource as "prometheus"
3. URL - http://prometheus-kube-prometheus-prometheus:9090
4. Test connection

<img width="1440" height="602" alt="Screenshot 2025-12-23 at 11 14 55 AM" src="https://github.com/user-attachments/assets/130ce9ac-778a-40dd-901f-1e331a630741" />

## Setup Dashboards
1. Kubernetes Nodes - 8171
2. K8s Dashboard - 15661

<img width="1440" height="602" alt="Screenshot 2025-12-23 at 11 18 32 AM" src="https://github.com/user-attachments/assets/4568492c-64fd-4520-b693-e956992de729" />

## Setup Alerts
1. Create custom contact point eg: Slack/SNS etc or the default one (Demo)
2. Create Alert Rule

## Uninstalling the Chart

To uninstall/delete deployment:

```console
helm delete grafana
```
