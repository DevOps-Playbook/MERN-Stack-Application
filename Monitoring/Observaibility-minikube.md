# Observability Setup

## Metrics vs Monitoring

Metrics are measurements or data points that tell you what is happening. For example, the number of steps you walk each day, your heart rate, or the temperature outside—these are all metrics.

Monitoring is the process of keeping an eye on these metrics over time to understand what’s normal, identify changes, and detect problems. It's like watching your step count daily to see if you're meeting your fitness goal or checking your heart rate to make sure it's in a healthy range.

## 🚀 Prometheus
- Prometheus is an open-source systems monitoring and alerting toolkit originally built at SoundCloud.
- It is known for its robust data model, powerful query language (PromQL), and the ability to generate alerts based on the collected time-series data.
- It can be configured and set up on both bare-metal servers and container environments like Kubernetes.

## 🏠 Prometheus Architecture
- The architecture of Prometheus is designed to be highly flexible, scalable, and modular.
- It consists of several core components, each responsible for a specific aspect of the monitoring process.

![prometheus-architecture](https://github.com/user-attachments/assets/6ef039e0-ee11-4fda-a153-b9b52244df4a)

### 🖥️ Prometheus Web UI
- The Prometheus Web UI allows users to explore the collected metrics data, run ad-hoc PromQL queries, and visualize the results directly within Prometheus.

### 📊 Grafana
- Grafana is a powerful dashboard and visualization tool that integrates with Prometheus to provide rich, customizable visualizations of the metrics data.

### 🔌 API Clients
- API clients interact with Prometheus through its HTTP API to fetch data, query metrics, and integrate Prometheus with other systems or custom applications.

# 🛠️  Installation & Configurations
### 📦 Step 1: Create Minikube Cluster - enable Minikube VM 

```bash
./cluster.sh
```

### 🧰 Step 2: Install prometheus-community Chart
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus
```

### 🚀 Step 3: Expose prometheus service and test the endpoint
```bash
kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext --port=9090
kubectl patch svc prometheus-server-ext -p '{"spec":{"ports":[{"port":9090,"targetPort":9090,"nodePort":32123}],"type":"NodePort"}}'
kubectl get svc
kubectl port-forward service/prometheus-server-ext 32123:9090 --address 0.0.0.0 &
```

### 🧰 Step 4: Install Grafana Chart
```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana grafana/grafana
```

### 🚀 Step 5: Expose Grafana service and test the endpoint
```bash
kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-ext --port=3000
kubectl patch svc grafana-ext -p '{"spec":{"ports":[{"port":3000,"targetPort":3000,"nodePort":32124}],"type":"NodePort"}}'
kubectl port-forward service/grafana-ext 32124:3000 --address 0.0.0.0 &
```

### ✅ Step 6: Setup Datasources 
1. Navigate to Grafana Dashboard
2. Add datasource as **"prometheus"**
3. URL - prometheus service URL

<img width="1440" alt="Screenshot 2024-12-03 at 4 50 28 PM" src="https://github.com/user-attachments/assets/5ec90f49-6825-4a77-927f-265dec629aa7">

4. Test connection "+"

<img width="1440" alt="Screenshot 2024-12-03 at 4 51 35 PM" src="https://github.com/user-attachments/assets/0302913d-a7d9-4ce1-a587-08357ba4809a">

### ✅ Step 7: Setup Dashboards
1. Go to Dashboards
2. Click "import"
3. Dashboard ID - 15661 --> Kubernetes for Prometheus dashboard
```bash
https://grafana.com/grafana/dashboards/15661-1-k8s-for-prometheus-dashboard-20211010/
```
4. Dashboard ID - 8171 --> Monitor nodes
```bash
https://grafana.com/grafana/dashboards/8171-kubernetes-nodes/
```
5. Dashboard ID - 3662 --> Prometheus 2.0
```bash
https://grafana.com/grafana/dashboards/3662-prometheus-2-0-overview/
```

6. There are many dashboards already available we can import as required by the datasources

```bash
https://grafana.com/grafana/dashboards/?search=prometheus
```

